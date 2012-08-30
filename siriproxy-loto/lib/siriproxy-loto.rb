# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'nokogiri'

class SiriProxy::Plugin::Loto < SiriProxy::Plugin
	def initialize(config)
	end
	
	filter "SetRequestOrigin", direction: :from_iphone do |object|
		if object["properties"]["status"] != "Denied"
			@latitude = object["properties"]["latitude"]
			@longitude = object["properties"]["longitude"]
		else
			@latitude = nil
			@longitude = nil
		end
	end
	listen_for /r.sultat(.*)loto/i do |ph|
	
		uri = "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{@latitude},#{@longitude}&sensor=false&language=fr-FR"
		response = HTTParty.get(uri)
		country = ""
		if response["status"] == "OK"
			components = response["results"][0]["address_components"]
			components.each do |comp|
				if comp["types"].include?("country")
					country = comp["short_name"]
				end
			end
		end
		
		if country == "BE"
			uri = "http://www.lotto.be/soap2/lotto.asmx/LatestDraw?User=appsolution&Password=appsolutionwebservice"
			response = HTTParty.get(uri)
			date = response["Draw"]["DrawDate"]
			date = "#{date[8..9]}/#{date[5..6]}/#{date[0..3]}"
			i = 1;
			nums = []
			response["Draw"]["Results"].each do |num|
				if i == 7 #last
					nums.push("et le numéro complémentaire est le #{num[1]}")
				else
					nums.push(num[1])
				end
				i = i+1
			end
			say "Voici les résultats du lotto pour le #{date} : "
			say nums.join(" "), spoken: nums.join(", ")		
		else		
			response = HTTParty.get("https://www.fdj.fr/jeux/loto/tirage")
			doc = Nokogiri::HTML(response)
			title = doc.css("#loto_title").first.content.downcase
			nums = []
			doc.css("#listeBoulesloto p").each do |p|
				nums.push(p.content)
			end
			say "Voici les résultats du loto pour le #{title} : "
			say nums.join(" "), spoken: nums.join(", ")
		end
		request_completed
	end
	
	listen_for /r.sultat(.*)euro million/i do |ph|
		response = HTTParty.get("https://www.fdj.fr/jeux/euromillions/tirage")
		doc = Nokogiri::HTML(response)

		title = doc.css(".dateTirage").first.content

		result = "#{title} : "
		result_spoken =  "#{title} : "
		doc.css(".euromillions_numeros p.euro_num").each do |p|
			result += "#{p.content} "
			result_spoken += "#{p.content}, "
		end
		result_spoken += "Et les étoiles : "
		doc.css(".euromillions_numeros p.euro_num_c").each do |p|
			result += "#{p.content} "
			result_spoken += "#{p.content}, "
		end
		say "Voici les résultats de l'Euro Millions : "
		say result, spoken: result_spoken
		request_completed
	end
	
end
