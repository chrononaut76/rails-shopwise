require 'open-uri'
require 'json'
require 'dotenv'
Dotenv.load('../.env')

# # load the file:
# if File.file?(file_path)
#   file = File.read(file_path)
# # store the data to a file:
# File.write("storage/#{key}#{i}.json", JSON.dump(data))

url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV.fetch('EDAMAM_APP_ID')}&app_key=#{ENV.fetch('EDAMAM_API_KEY')}&nutrition-type=cooking"
5.times do
  response = URI.open(url).read
  File.open("../storage/edamam.json", "wb") do |file|
    file.write(response)
  end
  json = JSON.parse(response)
  url = json.dig('_links', 'next', 'href')
end
