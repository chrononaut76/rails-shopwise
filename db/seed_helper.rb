require 'open-uri'
require 'json'
# require 'dotenv'
# Dotenv.load('.env')

url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV.fetch('EDAMAM_APP_ID')}&app_key=#{ENV.fetch('EDAMAM_API_KEY')}&nutrition-type=cooking"

5.times do |index|
  response = URI.open(url).read
  json = JSON.parse(response)
  File.write("storage/edamam_#{index + 1}.json", JSON.dump(json))
  next_page = json.dig('_links', 'next', 'href')
  prng = Random.new
  next_session = (40 * prng.rand(1..50)).to_s
  url = next_page.sub(/\d\d+/, next_session)
end
