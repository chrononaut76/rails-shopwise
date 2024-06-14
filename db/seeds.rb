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

# Purge contents of all tables
puts "Purging all tables..."
UserItem.destroy_all
StoreItem.destroy_all
Store.destroy_all
Item.destroy_all
User.destroy_all

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
  name: 'Provigo',
  address: '50 Mont-Royal Ave W, Montreal, Quebec',
  image_url: 'https://lh3.googleusercontent.com/p/AF1QipOiKNWn4GL1z3Czdv-Gr7lJ2cyUeCi_5ih47G0x=s1360-w1360-h1020'
).name}"
puts "  Created #{Store.create!(
  name: 'Metro',
  address: '1293 Laurier Ave E, Montreal, Quebec H2J 1H2',
  image_url: 'https://lh5.googleusercontent.com/-qgyoULa4YbI/V0uVJ3dx56I/AAAAAAAAi10/MXU45riP6FoqltvxMZ4_OrLZVlk8-4vRwCLIB/s1600-w640/'
).name}"
puts "  Created #{Store.create!(
  name: 'P&A Nature',
  address: '5029 Park Ave, Montreal, Quebec',
  image_url: 'https://lh3.googleusercontent.com/p/AF1QipOE4iP3L1XPAF-OZdrKICgsr5JQalluONUdePHc=s1360-w1360-h1020'
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
  name: 'PA',
  address: '5242 Park Ave, Montreal, Quebec H2V 4G7',
  image_url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHqx-pcSk2lEC3U8H6O3BI_uuQFuEz7E_AKQ&s'
).name}"
puts "  Created #{Store.create!(
  name: 'Super C',
  address: '2035 R. Atateken, Montreal, Quebec',
  image_url: 'https://lh3.googleusercontent.com/p/AF1QipNw3X0DzU86pQUFXiC5n1dLV02MfhNfjX-BRcyK=s1360-w1360-h1020'
).name}"
puts "\nSeeding stores complete!\n\n"

# Seed 'Items' table
puts 'Creating items...'

# Random items from JSON files
food_items = []
10.times do |index|
  filepath = "db/edamam-storage/edamam_recipes_#{index + 1}.json"
  file = File.read(filepath)
  data = JSON.parse(file).deep_symbolize_keys

  food_items << data[:hits].flat_map do |hit|
    hit.dig(:recipe, :ingredients).map{|ingr| { name: ingr[:food], food_id: ingr[:foodId]}}
  end
end

food_items.flatten!&.uniq!

food_items.each do |item|
  next if Item.find_by(food_id: item[:food_id]).present?
  Item.create!(
    name: item[:name].downcase,
    food_id: item[:food_id]
  )
end
puts "  Created #{Item.count} items"

# Items for Demo Day
items_for_demo_day = [
  'penne pasta',
  'pesto',
  'salt',
  'pepper',
  'parmesan',
  'chicken breast',
  'olive oil',
  '7up',
  'Perrier'
]

items_for_demo_day.each do |item|
  puts "  Created #{
    Item.create!(
      name: item,
      food_id: Faker::Number.number(digits: 10)
    ).name
  }"
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
  price_offset = (-3.0..3.0).step(0.75).to_a.reverse
  price_offset.delete_if { |element| element.zero? }
  Store.all.each_with_index do |store, index|
    dollars = (5.0..15.0).step(1).to_a.sample
    cents = ((50.0..70.0).step(10).to_a.sample + 9.0) / 100
    StoreItem.create!(
      store_id: store.id,
      item_id: item.id,
      price: (dollars + cents + price_offset[index]).round(2)
    )
    puts "  Created #{StoreItem.count} store items" if (StoreItem.count % 100).zero?
  end
end
puts "  Created #{StoreItem.count} store items"
puts "\nSeeding store items complete!"
