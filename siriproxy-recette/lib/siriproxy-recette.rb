# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::Recette < SiriProxy::Plugin
	def initialize(config)
	end
	
	class OpenLink < SiriObject
	  def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	  end
	end
	add_property_to_class(OpenLink, :ref)

	def displayCost(num)
		rep = ""
		i = 0
		until i >= num  do
		rep += "€ "
		i += 1
	end
		return rep
	end

	listen_for /(recettes|recette) (.*)/i do |ph,query|
		query = query.strip
		query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("sur ","")

		uri = "http://m.marmiton.org/webservices/json.svc/GetRecipeSearch?SiteId=1&KeyWord=#{URI.encode(query)}&SearchType=0&ItemsPerPage=10&StartIndex=1"
		response = HTTParty.get(uri)

		recettes = response["data"]["items"]

		if recettes.empty?
			say "Je n'ai trouvé aucune recette pour #{query}."
		else
			say "J'ai trouvé au moins #{recettes.size} résultats :"
			recettes.each do |recette|
				id = recette["id"]
				url = "http:www.marmiton.org/recettes/recette_s_#{id}.aspx"
				title = recette["title"]
				if recette["pictures"].empty? or recette["pictures"].size < 2
					image = "http://www.marmiton.org/Skins/Common/Images/logo-marmiton-2.gif"
				else
					image = recette["pictures"][1]["url"]
				end
				if recette["difficulty"].nil?
					difficulty = "Inconnue"
				else
					difficulty = recette["difficulty"]
					if difficulty == 1 then
						difficulty = "Très facile"
					elsif difficulty == 2 then
						difficulty = "Facile"
					elsif difficulty == 3 then
						difficulty = "Moyennement difficile"
					elsif difficulty == 4 then
						difficulty = "Difficile"
					end
				end
				
				description = "#{recette["dishType"]["label"]}\n"
				description += "Difficulté : #{difficulty}\n"
				description +=  "Prix : #{displayCost(recette["cost"])}\n"
				description +=  "Note : #{recette["rating"]}/5 (#{recette["ratingCount"]} votes)\n"
				
				view = SiriAddViews.new
				view.make_root(last_ref_id)
				view.views << SiriAnswerSnippet.new([SiriAnswer.new(title, [SiriAnswerLine.new("logo",image),SiriAnswerLine.new(description)])])
				view.views << SiriButton.new("Voir la recette", [OpenLink.new(url.gsub("//",""))])
				send_object view
				
			end
		end

		request_completed
	end
end