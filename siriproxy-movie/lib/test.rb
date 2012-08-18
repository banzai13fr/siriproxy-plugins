# -*- encoding : utf-8 -*-
require 'pp'
require 'httparty'
require 'json'

class Allocine
  include HTTParty
  format :json
end

uri = "http://api.allocine.fr/rest/v3/movielist?partner=YW5kcm9pZC12M3M&count=15&filter=nowshowing&page=1&order=datedesc&format=json"
response = Allocine.get(uri)

first = true
response["feed"]["movie"].each do |movie|
	title = movie["title"]
	synopsis = movie["synopsisShort"]
	if movie.include?('poster')
		poster = movie["poster"]["href"]
	else
		poster = ""
	end
	release = movie["release"]["releaseDate"]
	week = Integer(movie["statistics"]["releaseWeekPosition"])
	
	if week == 0
		if(first)
			puts release.split("-").reverse.join('/')
			first = false
		end
		puts title
	end
end