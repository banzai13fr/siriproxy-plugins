# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'httparty'
require 'json'

class SiriProxy::Plugin::Translate < SiriProxy::Plugin
	def initialize(config)
		# Get your keys at https://datamarket.azure.com/developer/applications/
		@bing_clientid = config["api_bing_clientid"]
		@bing_clientsecret = config["api_bing_clientsecret"]
	end
	
	def translation(english)
		lang = user_language()[0..1]
		if english == "I don't know this language."
			if lang == "fr"
				return "Je ne connais pas cette langue."
			end
		elsif english == "Your Bing keys are not valid."
			if lang == "fr"
				return "Vos clés Bing ne sont pas valides."
			end
		elsif english == "I can't translate %1$s in %2$s."
			if lang == "fr"
				return "Je n'arrive pas à traduire %1$s en %2$s."
			end
		end
	end
	
	listen_for /(Traduit|Traduire|Traduis|Translate)(.*) (en|in|to) (.*)/i do |ph,text,ph2,dest|
		dest = dest.strip.downcase
		text = text.strip
		target = ""
		
		lang = user_language[0..1]
		if lang == "fr"
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
		else
			languages = {
				"english" => "en","arabic" => "ar","bulgarian" => "gb","catalan" => "ca","chinese" => "zh-CHS","chinese traditional" => "zh-CHT",
				"czech" => "cs","danish" => "da","dutch" => "nl",
				"estonian" => "et","finnish" => "fi","french" => "fr","german" => "de","greek" => "el","haitian" => "ht",
				"hebrew" => "he","hindi" => "hi","hungarian" => "hu","indonesian" => "id",
				"italian" => "it","japanese" => "ja","korean" => "ko","latvian" => "lv","lithuanian" => "lt","norwegian" => "no",
				"polish" => "pl","portuguese" => "pt","romanian" => "ro","russian" => "ru","slovak" => "sk","slovenian" => "sl",
				"spanish" => "es","swedish" => "sv","thai" => "th","turkish" => "tr",
				"ukrainian" => "uk","vietnamese" => "vi",
			}
		end

		languages.each do |name,code|
			if dest.include?(name)
				target = code
				break
			end
		end
		
		if target.empty?
			say translation("I don't know this language.")
		else
			uri = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
			response = HTTParty.post(uri, :body => {:grant_type => "client_credentials", :scope => "http://api.microsofttranslator.com", :client_id => URI.encode(@bing_clientid), :client_secret => URI.encode(@bing_clientsecret)})

			access_token = nil
			if !response["access_token"].nil?
				access_token = response["access_token"]
			else
				say translation("Your Bing keys are not valid.")
				request_completed
				return
			end

			if !access_token.nil?
				uri = "http://api.microsofttranslator.com/v2/Http.svc/Translate?text=#{URI.encode(text)}&from=#{lang}&to=#{target}"
				response = HTTParty.get(uri, :headers => {"Authorization" => "Bearer #{access_token}"})
				if !response["string"].nil?
					say response["string"]
				else
					say sprintf(translation("I can't translate %1$s in %2$s."), text, dest)
				end
			end
		end
		request_completed
	end
end