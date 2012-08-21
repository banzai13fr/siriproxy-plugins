# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::Picture < SiriProxy::Plugin
	def initialize(config)
	end
  
	listen_for /(photos?|images?|dessins?|illustrations?|affiche.moi|dessine.moi|pictures?|drawing|show me) (.*)/i do |ph,query|

		query = query.strip
		query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("d'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","").gsub("the ","").gsub("of ","").gsub("for ","").gsub("an ","")
		url = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{URI.encode(query)}"

		jsonString = Net::HTTP.get(URI.parse(url))
		json = JSON.parse(jsonString)

		if json["responseData"]['results'] != nil and json["responseData"]['results'].size > 0
			image = json['responseData']['results'][0]['unescapedUrl']
			
			object = SiriAddViews.new
			object.make_root(last_ref_id)
			answer = SiriAnswer.new("Image :", [
				SiriAnswerLine.new("logo", "#{image}")
			])
			object.views << SiriAnswerSnippet.new([answer])
			send_object object

		else
			lang = user_language[0..1]
			if lang == "fr"
				say "Je n'ai trouvé aucune image."
			else
				say "I don't find any picture."
			end
		end

		request_completed
	end
	
end
