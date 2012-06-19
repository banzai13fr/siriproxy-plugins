# -*- encoding : utf-8 -*-
require 'pp'
require 'httparty'
require 'json'

query = "display le recorder"
query = query.strip
query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","")
uri = "http://itunes.apple.com/search?term=#{URI.encode(query)}&country=fr&media=software&entity=software&limit=5&genreId=&version=2&output=json&callback="
response = HTTParty.get(uri)

count = Integer(response["resultCount"])
if count > 0
	puts "Voici #{count} applications pour #{query} :"
	response["results"].each do |app|
		title = app["trackName"]
		description = app["description"]
		price = Float(app["price"])
		image = app["artworkUrl512"]
		url = app["trackViewUrl"].sub("//","")
		if price == 0
			price = "Gratuit"
		else
			price = "#{price} €"
		end
		size = "#{(Float(app["fileSizeBytes"])/1048576).round(2)} Mo"
		categories = app["genres"].join(', ')
				
		exit
	end
else
	puts "Je n'ai trouvé aucun résultat."
end