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

# Purge contents of 'UserItems' table
unless UserItem.all.empty?
  puts "Purging 'UserItems' table..."
  UserItem.destroy_all
end

# Purge contents of 'Users' table
unless User.all.empty?
  puts "Purging 'Users' table..."
  User.destroy_all
end

# Purge contents of 'StoreItems' table
unless StoreItem.all.empty?
  puts "Purging 'StoreItems' table..."
  StoreItem.destroy_all
end

# Purge contents of 'Stores' table
unless Store.all.empty?
  puts "Purging 'Stores' table..."
  Store.destroy_all
end

# Purge contents of 'Items' table
unless Item.all.empty?
  puts "Purging 'Items' table..."
  Item.destroy_all
end

# Seed 'Users' table
puts "\nCreating users..."
3.times do
  puts "  Created #{User.create!(email: Faker::Internet.email, password: '123456').email}"
end
puts "\nSeeding users complete!\n\n"

# Seed 'Stores' table
puts 'Creating stores...'
puts "  Created #{Store.create!(
  name: 'IGA',
  address: '900 Rue Saint-Zotique, Montreal, Quebec H2S 1M8',
  image_url: 'https://lh3.googleusercontent.com/p/AF1QipNzXIZMV72kFHNKXYSplOptzskjABtttTgRq2La=s1360-w1360-h1020'
).name}"
puts "  Created #{Store.create!(
  name: 'Metro',
  address: '1293 Laurier Ave E, Montreal, Quebec H2J 1H2',
  image_url: 'https://lh5.googleusercontent.com/-qgyoULa4YbI/V0uVJ3dx56I/AAAAAAAAi10/MXU45riP6FoqltvxMZ4_OrLZVlk8-4vRwCLIB/s1600-w640/'
).name}"
puts "  Created #{Store.create!(
  name: 'PA',
  address: '5242 Park Ave, Montreal, Quebec H2V 4G7',
  image_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHqx-pcSk2lEC3U8H6O3BI_uuQFuEz7E_AKQ&s'
).name}"
puts "  Created #{Store.create!(
  name: 'Provigo',
  address: '50 Mont-Royal Ave W, Montreal, Quebec',
  image_url: 'https://10619-2.s.cdn12.com/rests/original/104_505295181.jpg'
).name}"
puts "  Created #{Store.create!(
  name: 'Intermarché Boyer',
  address: '1000 Mont-Royal Ave E, Montreal, Quebec',
  image_url: 'https://mma.prnewswire.com/media/1058031/Intermarch__Boyer_L__picerie_Intermarch__Boyer_fait_12_choix__co.jpg'
).name}"
puts "  Created #{Store.create!(
  name: 'Maxi',
  address: '375 Rue Jean-Talon O, Montreal, Quebec',
  image_url: 'https://la-gare-jean-talon.weebly.com/uploads/7/8/2/0/78202338/9528564.png'
).name}"
puts "  Created #{Store.create!(
  name: 'P&A Nature',
  address: '5029 Park Ave, Montreal, Quebec',
  image_url: 'https://lh3.googleusercontent.com/p/AF1QipOE4iP3L1XPAF-OZdrKICgsr5JQalluONUdePHc=s1360-w1360-h1020'
).name}"
puts "  Created #{Store.create!(
  name: 'Super C',
  address: '2035 R. Atateken, Montreal, Quebec',
  image_url: 'https://lh3.googleusercontent.com/p/AF1QipNw3X0DzU86pQUFXiC5n1dLV02MfhNfjX-BRcyK=s1360-w1360-h1020'
).name}"
puts "\nSeeding stores complete!\n\n"

# Seed 'Items' table
puts 'Creating items...'

# Items for Demo Day
Item.create!(name: 'penne pasta', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'pesto', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'salt', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'pepper', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'parmesan', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'chicken breast', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'olive oil', food_id: Faker::Number.number(digits: 10))
Item.create!(name: '7up', food_id: Faker::Number.number(digits: 10))
Item.create!(name: 'Perrier', food_id: Faker::Number.number(digits: 10))

# Random items from API
url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV.fetch('EDAMAM_APP_ID')}&app_key=#{ENV.fetch('EDAMAM_API_KEY')}&nutrition-type=cooking"
5.times do
  response = URI.open(url).read
  json = JSON.parse(response)
  json['hints'].each do |item|
    food_name = item.dig('food', 'label')
    food_id = item.dig('food', 'foodId')
    Item.create!(
      name: food_name.downcase,
      food_id: food_id
    ) unless Item.find_by(food_id: food_id).present?
  end
  puts "  Created #{Item.count} items"
  # prng = Random.new
  # next_session = (40 * prng.rand(1..50)).to_s
  # url = next_page.sub(/\d\d+/, next_session)
end
puts "\nSeeding items complete!\n\n"

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
puts "Seeding user items complete!\n\n"

# Seed 'StoreItems' table
puts 'Creating store items with prices...'
Item.all.each do |item|
  Store.all.each do |store|
    dollars = (5.0..15.0).step(1).to_a.sample
    cents = ((50.0..70.0).step(10).to_a.sample + 9.0) / 100
    StoreItem.create!(
      store_id: store.id,
      item_id: item.id,
      price: (dollars + cents).round(2)
    )
    puts "  Created #{StoreItem.count} store items" if (StoreItem.count % 100).zero?
  end
end
puts "\nSeeding store items complete!"
