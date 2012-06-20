# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::Help < SiriProxy::Plugin
	def initialize(config)
	end
	
	class OpenLink < SiriObject
	  def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	  end
	end
	add_property_to_class(OpenLink, :ref)

	listen_for /(extensions? install|fonctions? suppl)/i do
		answers = []
		Dir.glob(File.dirname(__FILE__)+"/../../siriproxy-*") do |dir|
			readme = dir+"/README.md"

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
		view.views << SiriAssistantUtteranceView.new("Il y a #{answers.size} plugins installés.")
		view.views << SiriAnswerSnippet.new(answers)
		send_object view
	end
end