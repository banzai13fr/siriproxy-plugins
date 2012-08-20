# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'json'
require 'active_support/core_ext'
require 'i18n'
require 'nokogiri'

class SiriProxy::Plugin::Dictionary < SiriProxy::Plugin
	def initialize(config)
	end
  
	listen_for /définitions? (.*)|definitions? (.*)|define (.*)/i do |query|

		query = query.strip
		query = query.gsub("la ","").gsub("les ","").gsub("le ","").gsub("l'","").gsub("d'","").gsub("des ","").gsub("de ","").gsub("du ","").gsub("une ","").gsub("un ","").gsub("dans ","").gsub("pour ","").gsub("the ","").gsub("of ","").gsub("for ","")
		query = query.mb_chars.normalize(:kd).to_str.gsub(/\p{Mn}/, '')
		url = "http://www.google.com/dictionary/json?callback=dict_api.callbacks.id100&q=#{URI.encode(query)}&sl=#{user_language}&tl=#{user_language}&restrict=pr%2Cde&client=te"

		jsonString = Net::HTTP.get(URI.parse(url))
		jsonString = jsonString.gsub(",200,null)","").gsub("dict_api.callbacks.id100(","")
		jsonString = jsonString.gsub('\\x3c','').gsub('\\x3d','').gsub('\\x3e','').gsub('\\x22','').gsub('\\x26','').gsub("#39;","'")
		json = JSON.parse(jsonString)

		if json["webDefinitions"] != nil
			definition = json["webDefinitions"][0]["entries"][0]["terms"][0]["text"]
		elsif user_language == "fr-FR"
			definition = "Je n'ai trouvé aucune définition."
		else
			definition = "I haven't found any definition."
		end
		
		say definition
		request_completed
	end
		
	listen_for /synonymes? (.*)/i do |query|

		query = query.strip
		query = query.sub('d\'','').sub('l\'','').sub('le ','').sub('du ','').sub('de ','').sub('pour ','')
		response = HTTParty.get("http://www.synonymo.fr/synonyme/#{URI.encode(query)}")
		doc = Nokogiri::HTML(response)

		results = doc.css(".fiche .word")
		if results.empty?
			say "Je n'ai trouvé aucun synonyme pour #{query}."
		else
			say "J'ai trouvé #{results.size} synonymes pour #{query} :"
			doc.css(".fiche .word").each do |a|
				say a.content
			end
		end
		request_completed
	end

	listen_for /antonymes? (.*)/i do |query|

		query = query.strip
		query = query.sub('d\'','').sub('l\'','').sub('le ','').sub('du ','').sub('de ','').sub('pour ','')
		response = HTTParty.get("http://www.antonyme.org/antonyme/#{URI.encode(query)}")
		doc = Nokogiri::HTML(response)

		results = doc.css(".fiche .word")
		if results.empty?
			say "Je n'ai trouvé aucun antonyme pour #{query}."
		else
			say "J'ai trouvé #{results.size} antonymes pour #{query} :"
			doc.css(".fiche .word").each do |a|
				say a.content
			end
		end
		request_completed
	end
	
end