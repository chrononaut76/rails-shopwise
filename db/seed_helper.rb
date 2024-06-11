require 'open-uri'
require 'json'

# run the script from the repo root: ruby db/seed_helper.rb
require 'dotenv' # uncomment to use in development
Dotenv.load('.env')

filters = "&diet=balanced&dishType=Bread&dishType=Cereals&dishType=Main%20course&dishType=Preps&dishType=Salad&dishType=Sandwiches&dishType=Side%20dish&dishType=Soup&dishType=Starter&imageSize=THUMBNAIL"
url = "https://api.edamam.com/api/recipes/v2?type=public&app_id=#{ENV.fetch('EDAMAM_RECIPE_API_APP_ID')}&app_key=#{ENV.fetch('EDAMAM_RECIPE_API_KEY')}#{filters}"
10.times do |index|
  sleep(30) if index == 5 # avoid reaching the API's rate limits
  response = URI.open(url).read
  data = JSON.parse(response)
  File.write("storage/edamam_recipes_#{index + 1}.json", JSON.dump(data))
  next_page = data.dig("_links", "next", "href")
  url = next_page
end
