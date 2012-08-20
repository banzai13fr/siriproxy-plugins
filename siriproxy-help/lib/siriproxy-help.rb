# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::Help < SiriProxy::Plugin
	def initialize(config)
	end

	listen_for /(extensions? install|fonctions? suppl|addons? install|plugins? install)/i do
		answers = []
		lang = user_language[0..1]
		
		Dir.glob(File.dirname(__FILE__)+"/../../siriproxy-*") do |dir|
			
			if lang == "fr"
				readme = dir+"/README-FR.md"
			else
				readme = dir+"/README.md"
			end
			
			# Default README
			if !File.exist?(readme)
				readme = dir+"/README.md"
			end

			name = ""
			description = []
			
			title_found = false
			is_description = false
			
			prev_ligne = ""
			
			if File.exist?(readme)	
				File.open(readme,"r:UTF-8").each_line do |ligne|
					if !title_found and ligne.start_with?("==")
						name = prev_ligne
						title_found = true
						is_description = true
					elsif is_description and ligne.start_with?("--")
						description.pop
						is_description = false
					elsif is_description
						ligne = ligne.strip
						if !ligne.empty?
							description.push(ligne)
						end
					else 
						prev_ligne = ligne
					end
				end
			
				description = description.join("\n")
				answers.push(SiriAnswer.new(name, [SiriAnswerLine.new(description)]))
			end
		end
		
		view = SiriAddViews.new
		view.make_root(last_ref_id)
		if lang == "fr"
			view.views << SiriAssistantUtteranceView.new("Il y a #{answers.size} plugins installés.")
		else
			view.views << SiriAssistantUtteranceView.new("There are #{answers.size} plugins installed.")
		end
		view.views << SiriAnswerSnippet.new(answers)
		send_object view
		request_completed
	end
end