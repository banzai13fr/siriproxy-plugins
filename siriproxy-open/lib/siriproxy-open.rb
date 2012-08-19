# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'

class SiriProxy::Plugin::Open < SiriProxy::Plugin
	def initialize(config)
	end
	  
	listen_for /ouvrir(.*)/i do |query|
		search = WebSearch.new(last_ref_id,"",query,"Bing")
		send_object search
		request_completed
	end
	
end
