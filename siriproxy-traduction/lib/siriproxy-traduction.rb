# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'json'

class SiriProxy::Plugin::Traduction < SiriProxy::Plugin
	def initialize(config)
		# Get your keys at https://datamarket.azure.com/developer/applications/
		@bing_clientid = config["api_bing_clientid"]
		@bing_clientsecret = config["api_bing_clientsecret"]
	end
	
	listen_for /(Traduit|Traduire|Traduis)(.*) en (.*)/i do |ph,text,lang|
		lang = lang.strip.downcase
		target = ""
		
		languages = {
			"anglais" => "en","arabe" => "ar","bulgare" => "gb","catalan" => "ca","chinois" => "zh-CHS","chinois traditionnel" => "zh-CHT",
			"tchèque" => "cs","tcheque" => "cs","dannois" => "da","nerlandais" => "nl","nérlandais" => "nl","néerlandais" => "nl",
			"estonien" => "et","finnois" => "fi","français" => "fr","francais" => "fr","allemand" => "de","grec" => "el","haitien" => "ht",
			"haïtien" => "ht","hebreu" => "he","hébreu" => "he","hindi" => "hi","hongrois" => "hu","indonésien" => "id","indonesien" => "id",
			"italien" => "it","japonais" => "ja","coréen" => "ko","coreen" => "ko","letton" => "lv","lituanien" => "lt","norvegien" => "no",
			"norvégien" => "no","polonais" => "pl","portugais" => "pt","roumain" => "ro","russe" => "ru","slovaque" => "sk","slovène" => "sl",
			"slovene" => "sl","espagnol" => "es","suédois" => "sv","suedois" => "sv","thai" => "th","thaï" => "th","turc" => "tr",
			"ukrainien" => "uk","vietnamien" => "vi","flamand" => "nl",
		}

		languages.each do |name,code|
			if lang.include?(name)
				target = code
				break
			end
		end

		if target.empty?
			say "Je ne connais pas cette langue."
		else
			uri = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
			response = HTTParty.post(uri, :body => {:grant_type => "client_credentials", :scope => "http://api.microsofttranslator.com", :client_id => URI.encode(@bing_clientid), :client_secret => URI.encode(@bing_clientsecret)})

			access_token = nil
			if !response["access_token"].nil?
				access_token = response["access_token"]
			else
				say "Vos clés Bing ne sont pas valides."
				request_completed
				return
			end

			if !access_token.nil?
				uri = "http://api.microsofttranslator.com/v2/Http.svc/Translate?text=#{URI.encode(text)}&from=fr&to=#{target}"
				response = HTTParty.get(uri, :headers => {"Authorization" => "Bearer #{access_token}"})
				if !response["string"].nil?
					say response["string"]
				else
					say "Je n'arrive pas à traduire #{text} en #{lang}"
				end
			end
		end
		request_completed
	end
end