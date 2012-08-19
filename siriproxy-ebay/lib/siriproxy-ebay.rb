# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'json'

class SiriProxy::Plugin::Ebay < SiriProxy::Plugin
	def initialize(config)
		# Get your key at https://developer.ebay.com/DevZone/account/
		@ebay_appname = config["api_ebay_appname"]
	end
	
	listen_for /ebay (.*)/i do |query|
		begin
			query = query.strip
			query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","")
			uri = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.12.00&SECURITY-APPNAME=#{@ebay_appname}&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=#{URI.encode(query)}&paginationInput.entriesPerPage=5&GLOBAL-ID=EBAY-FR"
			response = HTTParty.get(uri)
			
			if response["findItemsByKeywordsResponse"]["ack"] == "Success"
			
				count = Integer(response["findItemsByKeywordsResponse"]["searchResult"]["count"])
				
				if count > 0
					say "Voilà #{count} résultats :"
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
					say "Désolé, je n'ai trouvé aucun #{query} sur Ebay."
				end
			else
				say "Désolé, je ne peux pas traîter votre requête pour le moment."
			end
		rescue
			say "Une erreur inconnue est survenue lors de votre recherche sur Ebay."
		end
		request_completed
	end
end