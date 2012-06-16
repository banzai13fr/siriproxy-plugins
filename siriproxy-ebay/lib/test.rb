# -*- encoding : utf-8 -*-
require 'pp'
require 'httparty'
require 'json'

query = "iphone 4S neuf"
ebay_appname = "CdricBov-378b-4cd6-89e6-4775480d9b41"

query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","")
uri = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.12.00&SECURITY-APPNAME=#{ebay_appname}&RESPONSE-DATA-FORMAT=XML&REST-PAYLOAD&keywords=#{URI.encode(query)}&paginationInput.entriesPerPage=5&GLOBAL-ID=EBAY-FR"
response = HTTParty.get(uri)

begin
	if response["findItemsByKeywordsResponse"]["ack"] == "Success"
	
		count = Integer(response["findItemsByKeywordsResponse"]["searchResult"]["count"])
		
		if count > 0
			response["findItemsByKeywordsResponse"]["searchResult"]["item"].each do |item|
				title = item["title"].downcase.capitalize
				image = item["galleryURL"]
				location = item["location"]
				category = item["primaryCategory"]["categoryName"]
				status = item["sellingStatus"]["sellingState"]
				price = item["sellingStatus"]["convertedCurrentPrice"]
				price = "#{price["__content__"]} #{price["currencyId"]}"
				url = item["viewItemURL"].sub("//","")

				puts title
				puts url
				puts image
				puts location
				puts category
				puts status
				puts price
				puts ""
			end
		else
			puts "Désolé, je n'ai trouvé aucun #{query} sur Ebay."
		end
	else
		puts "Désolé, je ne peux pas traîter votre requête pour le moment."
	end
rescue
	puts "Une erreur inconnue est survenue lors de votre recherche sur Ebay."
end