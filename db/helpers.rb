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
f = File.open("../storage/edamam.json", "wb")
5.times do
  response = URI.open(url).read
  f.write(response)
  json = JSON.parse(response)
  url = json.dig('_links', 'next', 'href')
end
f.close
