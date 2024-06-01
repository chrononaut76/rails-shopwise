class UserItem < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :user_id, :item_id, presence: true

  private

  def recipes
    ingredients = []
    @user_items = UserItem.find_by(current_user)
    @user_items.each do |user_item|
      ingredients << Item.find_by(user_item).name
    end
    Rails.cache.fetch("#{cache_key_with_version}/recipes") do
      client = OpenAI::Client.new
      response = client.chat(parameters: {
        model: "gpt-3.5-turbo",
        messages: [{
          role: "user",
          content: "Recommend some simple recipes with ingredients #{ingredients.join}. Give me only the text of the recipe, without any of your own answer like 'Here is a simple recipe'."
        }]
      })
      response
    end
  end
end
