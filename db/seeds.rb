# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# require 'faker'
require 'open-uri'
require 'json'
# require 'watir'
# require 'nokogiri'

# url = "https://api.edamam.com/api/food-database/v2/parser?app_id=EDAMAM_APP_ID&app_key=EDAMAM_API_KEY&nutrition-type=cooking"
url = 'https://api.edamam.com/api/food-database/v2/parser?app_id=d8a7c33c&app_key=a657d89a37f29e8c714e10004c9f3613&nutrition-type=cooking'
until url.nil? do
  response = URI.open(url).read
  json = JSON.parse(response)
  json['hints'].each { |item| p Item.create!(name: item.dig('food', 'knownAs')) }
  url = json.dig('_links', 'next', 'href')
end
# def parser(url)
#   return URI.open(url).read
# rescue StandardError => e
#   puts "#{e}. Trying again..."
#   sleep 2
#   parser(url)
# end

# puts 'Creating browser instance'
# browser = Watir::Browser.new
# puts "Going to #{url}"
# browser.goto(url)
# puts 'Waiting for CSS selector presence'
# begin
#   js_doc = browser.elements(css: '.item-product__content') { |element| element.wait_until(&:present?) }
# rescue StandardError => e
#   puts e
# end
# puts 'Parsing data via Nokogiri'
# xml_doc = js_doc.each { |element| Nokogiri::HTML(element.inner_html) }
# puts 'Writing results to file'
# File.open('iga_grocery_items.html', 'wb') do |file|
#   xml_doc.each do |element|
#     file.write(element.title)
#   end
# end

# xml_doc.each do |element|
#   p element
#   element.search('.js-ga-productname') { |item| p item.text }
# end

# unless User.all.empty?
#   puts "Purging 'Users' table..."
#   User.all.each do |user|
#     User.destroy(user.id)
#     puts "  Records remaining: #{User.count}"
#   end
# end

# puts 'Creating users...'
# 2.times do
#   puts "  Created #{User.create!(email: Faker::Internet.email, password: '123456').email}"
# end
# puts "Seeding users complete!"

# unless Store.all.empty?
#   puts "Purging 'Stores' table..."
#   Store.all.each do |store|
#     Store.destroy(store.id)
#     puts "  Records remaining: #{Store.count}"
#   end
# end

# puts 'Creating stores...'
# # 2.times do
# puts "  Created #{Store.create!(
#   name: 'Metro Plus De la Montagne',
#   address: '1230 Rue Notre-Dame Ouest, Montréal, QC H3C 1K6',
#   image_url: 'http://localhost:3000',
#   longitude: 0,
#   latitude: 0
# ).name}"
# # end
# puts "Seeding stores complete!"
