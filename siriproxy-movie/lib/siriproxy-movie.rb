# -*- encoding : utf-8 -*-
require 'cora'
require 'siri_objects'
require 'pp'
require 'imdb'
require 'httparty'

class SiriProxy::Plugin::Movie < SiriProxy::Plugin
	def initialize(config)
	end

	class Allocine
	  include HTTParty
	  format :json
	end

	def translation(english)
		lang = user_language()[0..1]
		if english == "I can't find the movie %1$s."
			if lang == "fr"
				return "Je ne trouve pas le film #%1$s."
			end
		elsif english == "%1$s has a rating of %2$f/10."
			if lang == "fr"
				return "%1$s a une note de %2$f/10."
			end
		elsif english == "The main cast of the movie '%1$s' are %2&s."
			if lang == "fr"
				return "Les acteurs principaux du film %1$s are %2$s."
			end
		elsif english == "List of actors"
			if lang == "fr"
				return "Liste des acteurs"
			end
		elsif english == "%1$s has a rating of %2$f/10."
			if lang == "fr"
				return "%1$s a une note de %2$f/10."
			end
		elsif english == "You should probably not see it."
			if lang == "fr"
				return "Vous ne devriez probablement pas le regarder."
			end
		elsif english == "You should probably see it."
			if lang == "fr"
				return "Vous devriez probablement le regarder."
			end
		elsif english == "You should definitely see it."
			if lang == "fr"
				return "Vous devriez le voir absolument."
			end
		elsif english == "The main actor of the movie %1$s is %2$s."
			if lang == "fr"
				return "L'acteur principal du film %1$s est %2$s."
			end
		elsif english == "The director of the movie %1$s is %1$s."
			if lang == "fr"
				return "Le réalisateur du film %1$s est %1$s."
			end
		elsif english == "The movie %1$s was released on %2$s."
			if lang == "fr"
				return "Le film %1$s est sorti le %2$s."
			end
		elsif english == "Here is the movie poster of %1$s:"
			if lang == "fr"
				return "Voilà l'affiche du film %1$s :"
			end
		end
		return english
	end
	
	def getMovie(name)
		search = Imdb::Search.new(name)
		if search.movies.length >= 1
			return search.movies[0]
		else
			say sprintf(translation("I can't find the movie %1$s."), name)
			request_completed
			return nil
		end
	end

	listen_for /(qui a joué dans le film|qui a joué dans|qui joue dans le film|qui est dans le film|qui joue dans|acteurs? du film|acteurs? de|who played in|who plays in|main cast of) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			lignes = []
			mains = []
			movie.cast_members.each do |member|
				lignes.push(SiriAnswerLine.new("#{member}"))
				if mains.length < 3
					mains.push(member)
				end
			end
			
			view = SiriAddViews.new
			view.make_root(last_ref_id)
			view.views << SiriAssistantUtteranceView.new(sprintf(translation("The main cast of the movie '%1$s' are %2$s."), movie.title, mains.join(', ')))
			view.views << SiriAnswerSnippet.new([SiriAnswer.new("List of actors", lignes)])
			send_object view
		end
		request_completed
	end	
	
	listen_for /(note du film|quelle est la note de|what is the score of|what.s the score of|the score of) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			say sprintf(translation("%1$s has a score of %2$f/10."), movie.title, movie.rating)
		end
		request_completed
	end
	
	listen_for /(devrai..je voir le film|devrai..je regarder le film|devrai. regarder le film|devrai. voir le film|que vau. le film|should i see|should i watch) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			rt = movie.rating
			if rt < 6
				say translation("You should probably not see it.")
			elsif rt < 8
				say translation("You should probably see it.")
			else
				say translation("You should definitely see it.")
			end
			say sprintf(translation("%1$s has a rating of %2$f/10."), movie.title, movie.rating)
		end
		request_completed
	end
	
	listen_for /(qui est l.acteur principal|acteur principal du film|acteur principal de|main actor of) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			say sprintf(translation("The main actor of the movie %1$s is %2$s."), movie.title, movie.cast_members.first)
		end
		request_completed
	end
	
	listen_for /(qui a réalisé le film|qui réalise le film|réalisateur du film|who directed|director of the movie) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			say sprintf(translation("The director of the movie %1$s is %1$s."), movie.title, movie.director.first)
		end
		request_completed
	end
		
	listen_for /(quand est sorti le film|sortie du film|date le film|when was released) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			say sprintf(translation("The movie %1$s was released on %2$s."), movie.title, movie.release_date)
		end
		request_completed
	end
	
	listen_for /(affiche du film|movie poster) (.*)/i do |ph,film|
		movie = getMovie(film)
		if movie != nil
			image = movie.poster
			view = SiriAddViews.new
			view.make_root(last_ref_id)
			view.views << SiriAssistantUtteranceView.new(sprintf(translation("Here is the movie poster of %1$s:"), movie.title))
			view.views << SiriAnswerSnippet.new([SiriAnswer.new(movie.title,[SiriAnswerLine.new("logo",image)])])
			send_object view			
		end
		request_completed
	end
	
	listen_for /sorti(.*)ciné/i do |ph|
		uri = "http://api.allocine.fr/rest/v3/movielist?partner=YW5kcm9pZC12M3M&count=15&filter=nowshowing&page=1&order=datedesc&format=json"
		response = Allocine.get(uri)

		first = true
		answers = []
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
					say "Voici les films sortis la semaine du #{release.split("-").reverse.join('/')} : "
					first = false
				end
				answers.push(SiriAnswer.new(title,[SiriAnswerLine.new("poster",poster),SiriAnswerLine.new(synopsis)]))
			end
		end
		view = SiriAddViews.new
		view.make_root(last_ref_id)
		view.views << SiriAnswerSnippet.new(answers)
		send_object view			
		request_completed
	end
	
	
end
