# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'

class SiriProxy::Plugin::Jokes < SiriProxy::Plugin
	def initialize(config)
		@dir = File.dirname(__FILE__)
	end
	
	class VieDeMerde
		include HTTParty
		format :xml
	end
	
	listen_for /(raconte|dis|dit) une blague/i do |ph|
		begin
			file = File.open(@dir+"/jokes-fr", "r:UTF-8")
			contents = file.read
			liste = contents.split('%')
			rand = rand(liste.length-1)
			blague = liste[rand].strip
			say blague
		rescue
			say "C'est l'histoire de..."
		end
		request_completed
	end
	
	listen_for /(tell|say) a joke/i do |ph|
		begin
			file = File.open(@dir+"/jokes-en", "r:UTF-8")
			contents = file.read
			liste = contents.split('%')
			rand = rand(liste.length-1)
			joke = liste[rand].strip
			say joke
		rescue
			say "It's the story of..."
		end
		request_completed
	end
	
	listen_for /vie de merde|vdm/i do
		uri = "http://www.vdm-iphone.com/v8/fr/random.php?cat=all&num_page=0"
		vdm = VieDeMerde.get(uri)
		if vdm != nil
			items = vdm["root"]["item"]
			rand = rand(items.length)
			say items[rand]["text"]
		end
		request_completed
	end
	
	listen_for /fuck my life|fml/i do
		uri = "http://www.vdm-iphone.com/v8/en/random.php?cat=all&num_page=0"
		vdm = VieDeMerde.get(uri)
		if vdm != nil
			items = vdm["root"]["item"]
			rand = rand(items.length)
			say items[rand]["text"]
		end
		request_completed
	end
	
	listen_for /dans ton chat/i do
		begin
			file = File.open(@dir+"/fortunes-dtc", "r:UTF-8")
			contents = file.read
			liste = contents.split('%')
			rand = rand(liste.length-1)
			dtc = liste[rand]
			dtc = dtc.slice(0..dtc.index("--")-1)
			say dtc
		rescue
			say "Désolé, je n'ai pas trouvé la liste des blagues. Pourtant, j'ai bien cherché dans ton chat."
		end
		request_completed
	end
	
	listen_for /chuck norris/i do
		lang = user_language[0..1]
		
		if lang == "fr"
			begin
				file = File.open(@dir+"/fortunes-cn", "r:UTF-8")
				contents = file.read
				liste = contents.split('%')
				rand = rand(liste.length-1)
				dtc = liste[rand].strip
				say dtc
			rescue
				say "Chuck Norris n'a pas besoin d'une liste de blagues pour être drôle. C'est la liste des blagues qui a besoin de Chuck Norris."
			end
		else
			uri = "http://api.icndb.com/jokes/random/"
			content = HTTParty.get(uri)
			if content["value"]["joke"] != nil
				say content["value"]["joke"].gsub("&quot;",'"')
			else
				say "Chuck Norris can't have a failure but icndb.com can."
			end
		end
		request_completed
	end

end
