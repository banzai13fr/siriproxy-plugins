# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::News < SiriProxy::Plugin
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
	
	class RSS
		include HTTParty
		format :xml
		
		def initialize(plugin, titre, uri, flux)
			rss = RSS.get(flux)
			answers = []
			if rss != nil
				rss["rss"]["channel"]["item"].each do |item|
					title = item["title"]
					image = item["description"][/.*<img.*src="([^"]*)"/,1]
					description = item["description"].gsub("<br />","\n").gsub(%r{</?[^>]+?>}, '').gsub("&#39;","'")
					if image != nil
						if image.index("http") == nil
							image = image.sub('//','http://')
						end
						answers.push(SiriAnswer.new(title, [SiriAnswerLine.new("logo",image),SiriAnswerLine.new("#{description}")]))
					elsif
						answers.push(SiriAnswer.new(title, [SiriAnswerLine.new("#{description}")]))
					end
				end

				view = SiriAddViews.new
				view.make_root(plugin.last_ref_id)
				view.views << SiriAnswerSnippet.new(answers)
				view.views << SiriButton.new("Google News", [OpenLink.new(uri.gsub("//",""))])
				plugin.send_object view
			end
			plugin.request_completed
		end
	end
	
	def translation(english)
		lang = user_language()[0..1]
		if english == "Here are the latest news:"
			if lang == "fr"
				return "Voici les dernières infos du jour :"
			end
		elsif english == "News"
			if lang == "fr"
				return "Actualité"
			end
		end
		return english
	end
	
	listen_for /actualité(.*)jour|today(.*)news|news(.*)today/i do |ph|
		latitude = @latitude
		longitude = @longitude
		
		country = ""
		ned = "us"
		uri = "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{latitude},#{longitude}&sensor=false&language=fr-FR"
		response = HTTParty.get(uri)
		if response["status"] == "OK"
			components = response["results"][0]["address_components"]
			components.each do |comp|
				if comp["types"].include?("country")
					country = comp["short_name"]
				end
			end
		end
		
		if country == "BE"
			ned = "#{user_language[0..1]}_be"
		elsif country == "CA"
			ned = "#{user_language[0..1]}_ca"
		elsif country == "CH"
			ned = "#{user_language[0..1]}_ch"
		elsif country == "MA"
			ned = "#{user_language[0..1]}_ma"
		elsif country == "SN"
			ned = "#{user_language[0..1]}_sn"
		else
			ned = country.downcase
		end
	
		say translation("Here are the latest news:")
		title = translation("News")
		uri = "https://news.google.com/"
		flux = "http://news.google.com/news/feeds?pz=1&cf=all&ned=#{ned}&output=rss"
		RSS.new(self,title,uri,flux)
	end
	
end
