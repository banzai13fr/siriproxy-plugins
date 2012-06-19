# -*- encoding : utf-8 -*-
require 'pp'
require 'httparty'

uri = "http://www.lotto.be/soap2/lotto.asmx/LatestDraw?User=appsolution&Password=appsolutionwebservice"
response = HTTParty.get(uri)

date = response["Draw"]["DrawDate"]
date = "#{date[8..9]}/#{date[5..6]}/#{date[0..3]}"

i = 1;
nums = []
response["Draw"]["Results"].each do |num|
	if i == 7 #last
		nums.push("et le numéro complémentaire est le #{num[1]}")
	else
		nums.push(num[1])
	end
	
	i = i+1
end

say "Voici les résultats du lotto pour le #{date} : "
say nums.join(" "), spoken: nums.join(", ")