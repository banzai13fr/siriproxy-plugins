# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::Youtube < SiriProxy::Plugin
	def initialize(config)
	end
	
	class OpenLink < SiriObject
	  def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	  end
	end
	add_property_to_class(OpenLink, :ref)

	listen_for /youtube (.*)/i do |query|

		query = query.strip
		query = query.gsub("sur ","").gsub("pour ","").gsub("les ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","")
		
		begin
			uri = "https://gdata.youtube.com/feeds/api/videos?hl=fr&q=#{URI.encode(query)}&orderby=relevance_lang_fr&max-results=5&v=2&alt=json";
			response = HTTParty.get(uri)

			count = Integer(response["feed"]["openSearch$totalResults"]["$t"])
			if count > 0
				say "Voici #{response["feed"]["entry"].size} vidéos pour #{query} : "
				response["feed"]["entry"].each do |entry|
					title = entry["title"]["$t"]
					category = entry["media$group"]["media$category"][0]["label"]
					image = entry["media$group"]["media$thumbnail"][2]["url"]
					#description = entry["media$group"]["media$description"]["$t"]
					url = entry["link"][0]["href"].sub("//","").sub("https","http")
					
					view = SiriAddViews.new
					view.make_root(last_ref_id)
					view.views << SiriAnswerSnippet.new([SiriAnswer.new(category, [SiriAnswerLine.new(title),SiriAnswerLine.new("logo",image)])])
					view.views << SiriButton.new("Voir la vidéo", [OpenLink.new(url)])
					send_object view
				end
			else
				say "Je n'ai trouvé aucune vidéo pour #{query}"
			end
		rescue
			say "Une erreur inconnue m'empêche de rechercher sur Youtube."
		end
		request_completed
	end
end