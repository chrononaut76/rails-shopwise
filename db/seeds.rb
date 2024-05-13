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
require 'nokogiri'

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

url = 'https://www.metro.ca/en/online-grocery/search-page-1'
begin
  response = URI.open(url).read
  xml_doc = Nokogiri::HTML(response)
  p xml_doc
  # xml_doc.search('.content__head').first do |item|
  #   puts item
  # end
rescue StandardError => e
  print e
end
