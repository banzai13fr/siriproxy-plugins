# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
#require 'json'

class SiriProxy::Plugin::Search < SiriProxy::Plugin
	def initialize(config)
		# Get your key at https://developer.ebay.com/DevZone/account/
		@ebay_appname = config["api_ebay_appname"]
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
		elsif english == "Here are %1$d results:"
			if lang == "fr"
				return "Voilà %1$d résultats :"
			end
		elsif english == "Sorry, I don't have any result for %1$s on Ebay."
			if lang == "fr"
				return "Désolé, je n'ai trouvé aucun %1$s sur Ebay."
			end
		elsif english == "Sorry, I can't process your request at this time."
			if lang == "fr"
				return "Désolé, je ne peux pas traîter votre requête pour le moment."
			end
		elsif english == "An unknown error occured while accessing Ebay."
			if lang == "fr"
				return "Une erreur inconnue est survenue lors de votre recherche sur Ebay."
			end
		elsif english == "Here are %1$d videos for %2$s on Youtube:"
			if lang == "fr"
				return "Voici %1$d vidéos pour %2$s :"
			end
		elsif english == "See the video"
			if lang == "fr"
				return "Voir la vidéo"
			end
		elsif english == "Sorry, I don't have any video for %1$s."
			if lang == "fr"
				return "Je n'ai trouvé aucune vidéo pour %1$s."
			end
		elsif english == "An unknown error occured while accessing Youtube."
			if lang == "fr"
				return "Une erreur inconnue m'empêche de rechercher sur Youtube."
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
	
	
	

	listen_for /ebay (.*)/i do |query|
		begin
			query = query.strip
			query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("d'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","").gsub("the ","").gsub("of ","").gsub("for ","").gsub("an ","")
			uri = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.12.00&SECURITY-APPNAME=#{@ebay_appname}&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=#{URI.encode(query)}&paginationInput.entriesPerPage=5&GLOBAL-ID=EBAY-FR"
			response = HTTParty.get(uri)
			
			if response["findItemsByKeywordsResponse"]["ack"] == "Success"
			
				count = Integer(response["findItemsByKeywordsResponse"]["searchResult"]["count"])
				
				if count > 0
					say sprintf(translation("Here are %1$d results:"), count)
					response["findItemsByKeywordsResponse"]["searchResult"]["item"].each do |item|
						title = item["title"].downcase.capitalize
						image = item["galleryURL"]
						location = item["location"]
						category = item["primaryCategory"]["categoryName"]
						status = item["sellingStatus"]["sellingState"]
						price = item["sellingStatus"]["convertedCurrentPrice"]
						price = "#{price["__content__"]} #{price["currencyId"]}"
						url = item["viewItemURL"].sub("//","")
						
						view = SiriAddViews.new
						view.make_root(last_ref_id)
						view.views << SiriAnswerSnippet.new([SiriAnswer.new(category, [SiriAnswerLine.new("logo",image),SiriAnswerLine.new(title),SiriAnswerLine.new("Statut : #{status}"),SiriAnswerLine.new("Emplacement : #{location}"),SiriAnswerLine.new("Prix : #{price}")])])
						view.views << SiriButton.new("Voir sur Ebay", [OpenLink.new(url)])
						send_object view
					end
				else
					say sprintf(translation("Sorry, I don't have any result for %1$s on Ebay."), query)
				end
			else
				say translation("Sorry, I can't process your request at this time.")
			end
		rescue
			say translation("An unknown error occured while accessing Ebay.")
		end
		request_completed
	end

	
	
    listen_for /(youtube|you tube) (.*)/i do |ph,query|

		query = query.strip
		query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("d'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","").gsub("the ","").gsub("of ","").gsub("for ","").gsub(" an ","")
		
		begin
			uri = "https://gdata.youtube.com/feeds/api/videos?hl=fr&q=#{URI.encode(query)}&orderby=relevance_lang_fr&max-results=5&v=2&alt=json";
			response = HTTParty.get(uri)

			count = Integer(response["feed"]["openSearch$totalResults"]["$t"])
			if count > 0
				say sprintf(translation("Here are %1$d videos for %2$s on Youtube:"), response["feed"]["entry"].size, query)
				response["feed"]["entry"].each do |entry|
					title = entry["title"]["$t"]
					category = entry["media$group"]["media$category"][0]["label"]
					image = entry["media$group"]["media$thumbnail"][2]["url"]
					#description = entry["media$group"]["media$description"]["$t"]
					url = entry["link"][0]["href"].sub("//","").sub("https","http")
					
					view = SiriAddViews.new
					view.make_root(last_ref_id)
					view.views << SiriAnswerSnippet.new([SiriAnswer.new(category, [SiriAnswerLine.new(title),SiriAnswerLine.new("logo",image)])])
					view.views << SiriButton.new(translation("See the video"), [OpenLink.new(url)])
					send_object view
				end
			else
				say sprintf(translation("Sorry, I don't have any video for %1$s."), query)
			end
		rescue
			say translation("An unknown error occured while accessing Youtube.")
		end
		request_completed
	end

end