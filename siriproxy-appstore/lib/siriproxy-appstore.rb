# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::Appstore < SiriProxy::Plugin
	def initialize(config)
	end
	
	class OpenLink < SiriObject
	  def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	  end
	end
	add_property_to_class(OpenLink, :ref)

	listen_for /(appstore|app store|applications? pour|applications? de|apps? to|applications? to|apps? of|applications? of|apps? for|applications? for) (.*)/i do |ph,query|
		query = query.strip
		query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","").gsub("the ","").gsub("of ","").gsub("for ","")
		uri = "http://itunes.apple.com/search?term=#{URI.encode(query)}&country=fr&media=software&entity=software&limit=5&genreId=&version=2&output=json&callback="
		
		begin
			response = HTTParty.get(uri)

			count = Integer(response["resultCount"])
			if count > 0
				say "Voici #{count} applications pour #{query} :"
				response["results"].each do |app|
					title = app["trackName"]
					description = app["description"].split("\n")[0]
					price = Float(app["price"])
					image = app["artworkUrl60"]
					url = app["trackViewUrl"].sub("//","")
					if price == 0
						price = "Gratuit"
					else
						price = "#{price} €"
					end
					size = "#{(Float(app["fileSizeBytes"])/1048576).round(2)} Mo"
					categories = app["genres"].join(', ')
					
					view = SiriAddViews.new
					view.make_root(last_ref_id)
					view.views << SiriAnswerSnippet.new([SiriAnswer.new(title, [SiriAnswerLine.new(categories),SiriAnswerLine.new("logo",image),SiriAnswerLine.new("Taille : #{size}"),SiriAnswerLine.new("Prix   : #{price}"),SiriAnswerLine.new(description)])])
					view.views << SiriButton.new("Voir dans l'AppStore", [OpenLink.new(url)])
					send_object view
				end
			else
				say "Je n'ai trouvé aucune application pour #{query}."
			end
		rescue
			say "Une erreur inconnue est survenue pendant l'accès à l'AppStore."
		end
		request_completed
	end
end