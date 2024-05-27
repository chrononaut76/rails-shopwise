require 'dotenv/load'
require 'open-uri'
require 'json'

query = 'bread'
url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV['EDAMAM_APP_ID']}&app_key=#{ENV['EDAMAM_API_KEY']}&ingr=#{query}"
response = URI.open(url).read
json = JSON.parse(response)
json['hints'].each do |item|
  p item.dig('food', 'foodId')
  p item.dig('food', 'knownAs')
end
