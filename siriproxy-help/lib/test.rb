# -*- encoding : utf-8 -*-
require 'pp'

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
		
		puts name
		puts description
	end
end