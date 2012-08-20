# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::Appstore < SiriProxy::Plugin
	def initialize(config)
	end
	
	def translation(english)
		lang = user_language()[0..1]
		if english == "Open in App Store"
			if lang == "fr"
				return "Voir dans l'App Store"
			end
		elsif english == "I found at least %1$d apps for %2$s:"
			if lang == "fr"
				return "J'ai trouvé au moins %1$d applications pour %2$s :"
			end
		elsif english == "Free"
			if lang == "fr"
				return "Gratuit"
			end
		elsif english == "An unknown error occured while accessing the App Store."
			if lang == "fr"
				return "Une erreur inconnue est survenue pendant l'accès à l'AppStore."
			end
		elsif english == "I don't have any application for %1$s."
			if lang == "fr"
				return "Je n'ai trouvé aucune application pour %1$s."
			end
		end
		return english
	end
	
	listen_for /(appstore|app store|applications? pour|applications? de|apps? to|applications? to|apps? of|applications? of|apps? for|applications? for) (.*)/i do |ph,query|
		query = query.strip
		query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("d'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","").gsub("the ","").gsub("of ","").gsub("for ","")
		uri = "http://itunes.apple.com/search?term=#{URI.encode(query)}&country=#{user_language[3..4]}&media=software&entity=software&limit=5&genreId=&version=2&output=json&callback="
		
		begin
			response = HTTParty.get(uri)

			count = Integer(response["resultCount"])
			if count > 0
				say sprintf(translation("I found at least %1$d apps for %2$s:"),count,query)
				response["results"].each do |app|
					title = app["trackName"]
					description = app["description"].split("\n")[0]
					price = Float(app["price"])
					image = app["artworkUrl60"]
					url = app["trackViewUrl"].sub("//","")
					if price == 0
						price = translation("Free")
					else
						price = "#{price}"
					end
					size = "#{(Float(app["fileSizeBytes"])/1048576).round(2)} Mo"
					categories = app["genres"].join(', ')
					
					view = SiriAddViews.new
					view.make_root(last_ref_id)
					view.views << SiriAnswerSnippet.new([SiriAnswer.new(title, [SiriAnswerLine.new(categories),SiriAnswerLine.new("logo",image),SiriAnswerLine.new("Taille : #{size}"),SiriAnswerLine.new("Prix   : #{price}"),SiriAnswerLine.new(description)])])
					view.views << SiriButton.new(translation("Open in App Store"), [OpenLink.new(url)])
					send_object view
				end
			else
				say sprintf(translation("I don't have any application for %1$s."), query)
			end
		rescue
			say translation("An unknown error occured while accessing the App Store.")
		end
		request_completed
	end
end