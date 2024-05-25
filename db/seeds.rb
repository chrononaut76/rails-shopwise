# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'
require 'faker'

# Purge contents of 'Users' table
unless User.all.empty?
  puts "Purging 'Users' table..."
  User.all.each do |user|
    User.destroy(user.id)
    puts "  Records remaining: #{User.count}"
  end
end

# Seed 'Users' table
puts 'Creating users...'
3.times do
  puts "  Created #{User.create!(email: Faker::Internet.email, password: '123456').email}"
end
puts "Seeding users complete!\n\n"

# Purge contents of 'Stores' table
unless Store.all.empty?
  puts "Purging 'Stores' table..."
  Store.all.each do |store|
    Store.destroy(store.id)
    puts "  Records remaining: #{Store.count}"
  end
end

# Seed 'Stores' table
puts 'Creating stores...'
5.times do
  puts "  Created #{Store.create!(
    name: Faker::Commerce.vendor,
    address: Faker::Address.full_address,
    image_url: Faker::Internet.url,
    longitude: Faker::Address.longitude,
    latitude: Faker::Address.latitude
  ).name}"
end
puts "Seeding stores complete!\n\n"

# Purge contents of 'Items' table
unless Item.all.empty?
  puts "Purging 'Items' table..."
  Item.all.each do |item|
    Item.destroy(item.id)
    puts "  Records remaining: #{Item.count}"
  end
end

# Seed 'Items' table
puts 'Creating items...'
# url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{EDAMAM_APP_ID}&app_key=#{EDAMAM_API_KEY}&nutrition-type=cooking"
url = 'https://api.edamam.com/api/food-database/v2/parser?app_id=d8a7c33c&app_key=a657d89a37f29e8c714e10004c9f3613&nutrition-type=cooking'
5.times do
  response = URI.open(url).read
  json = JSON.parse(response)
  json['hints'].each { |item| Item.create!(name: item.dig('food', 'knownAs')) }
  puts "  Created #{Item.count} items"
  next_page = json.dig('_links', 'next', 'href')
  prng = Random.new
  next_session = (40 * prng.rand(1..50)).to_s
  url = next_page.sub(/\d\d+/, next_session)
end
puts "Seeding items complete!\n\n"

# Purge contents of 'UserItems' table
unless UserItem.all.empty?
  puts "Purging 'UserItems' table..."
  UserItem.all.each do |user_item|
    UserItem.destroy(user_item.id)
    puts "  Records remaining: #{UserItem.count}"
  end
end

# Seed 'UserItems' table
User.all.each do |user|
  puts "Creating user items for #{user.email}..."
  5.times do
    prng = Random.new
    user_item = UserItem.create!(
      item_id: prng.rand(Item.first.id..Item.last.id),
      user_id: user.id
    )
    puts "  Created #{Item.find(user_item.item_id).name}"
  end
  puts "\n"
end
puts 'Seeding user items complete!'


Store.ids.each do |store_id|
  Item.ids.each do |item_id|
    StoreItem.create!(
    store_id: store_id,
    item_id: item_id,
    price: rand(1..20)
    )
     # create a StoreItem with store_id: and item_id:
end
end
