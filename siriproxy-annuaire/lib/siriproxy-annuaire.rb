# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::Annuaire < SiriProxy::Plugin
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

	class Annu
		include HTTParty
		format :json
	end	

	class OpenLink < SiriObject
	  def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	  end
	end
	add_property_to_class(OpenLink, :ref)

	listen_for /annuaire (.*)/i do |query|
	
		# Country lookup
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
	
		# Is it a where clause ?
		query =~ /(.*) (a|à|de|pour|dans|en|in) (.*)/i

		if !$1.nil?
			what = $1
			where = $3
		else
			what = query
			where = ""
		end
		
		what = what.gsub("zéros","0").gsub("zéro","0").gsub("zero","0").gsub(/(\d) /,'\1')
		where = where.gsub("zéros","0").gsub("zéro","0").gsub("zero","0").gsub(/(\d) /,'\1')

		# The real thing
		#country = "BE"
		if country == "BE"
			uri = "http://mobileproxy.truvo.net/BE/white/search.ds?platform=ipad&version=3&locale=fr_BE&what=#{URI.encode(what)}&where=#{URI.encode(where)}&distLatitude=#{URI.encode(@latitude.to_s)}&distLongitude=#{URI.encode(@longitude.to_s)}&activeSort=geo_spec_sortable"
			response = HTTParty.get(uri)
			if response["results"]["pagination"]["totalNumberOfResults"] != "0"
				if response["results"]["pagination"]["totalNumberOfResults"] == "1"
					listings = [response["results"]["listings"]["listing"]]
				else
					listings = response["results"]["listings"]["listing"]
				end
				listings.each do |listing|
					if !listing.include?("type") or listing["type"] != "ad"
						fiche = []
						fiche.push(listing["businessName"])
						fiche.push(listing["streetAddress"])
						fiche.push("#{listing["zipCode"]} #{listing["city"]}")
						if !listing["phoneNumbers"].nil?
							fiche.push(listing["phoneNumbers"]["number"])
						end
						say fiche.join("\n"),spoken: fiche.join(",\n")
					end
				end
			else
				say "Je n'ai trouvé aucun résultat."
			end
		else
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
					begin
						ec = Encoding::Converter.new("ISO-8859-1", "UTF-8")
						say ec.convert(fiche.join("\n")),spoken: ec.convert(fiche.join(",\n"))
					rescue
						say "Impossible d'afficher cette fiche."
					end
				end
			else
				say "Je n'ai trouvé aucun résultat."
			end
		end
		
		request_completed
	end
end