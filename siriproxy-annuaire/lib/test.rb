# -*- encoding : utf-8 -*-
require 'pp'
require 'httparty'

def say t,t2=""
	puts t
end

class Annu
	include HTTParty
	format :json
end

query = "boverie"

query =~ /(.*) (a|à|de|pour|dans|en|in) (.*)/i

if !$1.nil?
	what = $1
	where = $3
else
	what = query
	where = ""
end

uri = "http://v3.annu.com/cgi-bin/srch.cgi?j=1&s=#{URI.encode(what)},#{URI.encode(where)}&n=10"
response = Annu.get(uri)

if response["search_msg"] == "yes"
	response["liste_part"].each do |part|
		fiche = []
		fiche.push("#{part["firstname"]} #{part["name"]}")
		fiche.push(part["address"])
		fiche.push("#{part["zipcode"]} #{part["city"]}")
		
		part["numeros"].each do |num, val|
			if val.empty?
				fiche.push(num)
			else
				fiche.push("#{num} (#{val})")
			end
		end
		say fiche.join("\n"), fiche.join(",\n")
	end
else
	say "Je n'ai trouvé aucun résultat."
end

latitude = "{2}"
longitude = "{3}"

uri = "http://mobileproxy.truvo.net/BE/white/search.ds?platform=ipad&version=3&locale=fr_BE&what=#{URI.encode(what)}&where=#{URI.encode(where)}&distLatitude=#{URI.encode(latitude)}&distLongitude=#{URI.encode(longitude)}&activeSort=geo_spec_sortable"
response = HTTParty.get(uri)

if response["results"]["pagination"]["totalNumberOfResults"] != "0"
	response["results"]["listings"]["listing"].each do |listing|
		if listing["type"] != "ad"
			fiche = []
			fiche.push(listing["businessName"])
			fiche.push(listing["streetAddress"])
			fiche.push("#{listing["zipCode"]} #{listing["city"]}")
			if !listing["phoneNumbers"].nil?
				fiche.push(listing["phoneNumbers"]["number"])
			end
			say fiche.join("\n"), fiche.join(",\n")
		end
	end
else
	say "Je n'ai trouvé aucun résultat."
end