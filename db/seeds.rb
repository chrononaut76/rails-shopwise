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
  UserItem.all.each do |user_item|
    UserItem.destroy(user_item.id)
    # puts "  Records remaining: #{UserItem.count}"
  end
end

# Purge contents of 'Users' table
unless User.all.empty?
  puts "Purging 'Users' table..."
  User.all.each do |user|
    User.destroy(user.id)
    # puts "  Records remaining: #{User.count}"
  end
end

# Purge contents of 'StoreItems' table
unless StoreItem.all.empty?
  puts "Purging 'StoreItems' table..."
  StoreItem.all.each do |store_item|
    StoreItem.destroy(store_item.id)
    # puts "  Records remaining: #{StoreItem.count}"
  end
end

# Purge contents of 'Stores' table
unless Store.all.empty?
  puts "Purging 'Stores' table..."
  Store.all.each do |store|
    Store.destroy(store.id)
    # puts "  Records remaining: #{Store.count}"
  end
end

# Purge contents of 'Items' table
unless Item.all.empty?
  puts "Purging 'Items' table..."
  Item.all.each do |item|
    Item.destroy(item.id)
    # puts "  Records remaining: #{Item.count}"
  end
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
  image_url: Faker::Internet.url,
  # longitude: '-73.60587581893765',
  # latitude: '45.538247238071754'
).name}"
puts "  Created #{Store.create!(
  name: 'Metro',
  address: '1293 Laurier Ave E, Montreal, Quebec H2J 1H2',
  image_url: Faker::Internet.url,
  # longitude: '-73.5846618087831',
  # latitude: '45.53301240423875'
).name}"
puts "  Created #{Store.create!(
  name: 'PA',
  address: '5242 Park Ave, Montreal, Quebec H2V 4G7',
  image_url: Faker::Internet.url,
  # longitude: '-73.59859593459966',
  # latitude: '45.520535550344015'
).name}"
puts "  Created #{Store.create!(
  name: 'Provigo',
  address: '2386 Lucerne Rd, Mount Royal, Quebec H3R 2J8',
  image_url: Faker::Internet.url,
  # longitude: '-73.662023',
  # latitude: '45.506769'
).name}"
puts "\nSeeding stores complete!\n\n"

# Seed 'Items' table
puts 'Creating items...'
url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV.fetch('EDAMAM_APP_ID')}&app_key=#{ENV.fetch('EDAMAM_API_KEY')}&nutrition-type=cooking"
5.times do
  response = URI.open(url).read
  json = JSON.parse(response)
  json['hints'].each { |item| Item.create!(name: item.dig('food', 'knownAs').downcase, food_id: item.dig('food', 'foodId')) }
  puts "  Created #{Item.count} items"
  next_page = json.dig('_links', 'next', 'href')
  prng = Random.new
  next_session = (40 * prng.rand(1..50)).to_s
  url = next_page.sub(/\d\d+/, next_session)
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
    dollars = (1.0..3.0).step(1).to_a.sample
    cents = ((50.0..70.0).step(10).to_a.sample + 9.0) / 100
    StoreItem.create!(
      store_id: store.id,
      item_id: item.id,
      price: (dollars + cents).round(2)
    )
    puts "  Created #{StoreItem.count} store items" if (StoreItem.count % 40).zero?
  end
end
puts "\nSeeding store items complete!"
