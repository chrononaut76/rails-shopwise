class UserItemsController < ApplicationController
  def index
    @user_items = policy_scope(UserItem)
    @items = policy_scope(Item)
    @stores = policy_scope(Store)
    @item_ids = @user_items.map(&:item_id)

    if params[:query].present?
      @items = Item.search_by_name(params[:query])
      query_api if @items.empty?
    end

    respond_to do |format|
      format.html
      format.text { render partial: 'results', locals: { items: @items }, formats: [:html] }
    end
  end

  def create
    @user_item = UserItem.new
    @user_item.user = current_user
    @user_item.item = Item.find(params[:item_id])
    authorize @user_item
    redirect_to my_items_path, notice: 'Item added successfully.' if @user_item.save!
  end

  def destroy
    @user_item = UserItem.find(params[:id])
    authorize @user_item
    @user_item.destroy
    redirect_to my_items_path, status: :see_other
  end

  def recipes
    @user_items = UserItem.where(user_id: current_user.id)
    @recipes_list = recipes_list(@user_items)
    process_recipes(@recipes_list)
    authorize @user_items
  end

  private

  def query_api
    url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV.fetch('EDAMAM_RECIPE_API_APP_ID')}&app_key=#{ENV.fetch('EDAMAM_RECIPE_API_KEY')}&ingr=#{params[:query]}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['hints'].each do |item|
      unless Item.find_by(food_id: item.dig('food', 'foodId'))
        food_name = item.dig('food', 'label')
        food_id = item.dig('food', 'foodId')
        new_item = Item.create!({ name: food_name.downcase, food_id: food_id })
        add_store_item(new_item)
      end
    end
  end

  def add_store_item(new_item)
    Store.all.each do |store|
      dollars = (5.0..15.0).step(1).to_a.sample
      cents = ((50.0..70.0).step(10).to_a.sample + 9.0) / 100
      StoreItem.create!(
        store_id: store.id,
        item_id: new_item.id,
        price: (dollars + cents).round(2)
      )
    end
  end

  def recipes_list(user_items)
    ingredients = []
    user_items.each do |user_item|
      ingredients << Item.find(user_item.item_id).name
    end
    client = OpenAI::Client.new
    response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{
        role: "user",
        content: "Provide a recipe based on the following ingredients: #{ingredients.join}, the recipe should follow this specific format

        1. [Recipe's Name]

        - [Quantity] [Ingredient]
        - [Quantity] [Ingredient]
        - [Quantity] [Ingredient]

        2. [Write the instructions in one paragraph.]"
      }]
    })
    response["choices"][0]["message"]["content"]
  end

  def process_recipes(recipes_list)
    current_recipe = { name: "", ingredients: [], instructions: "" }

    recipes_list.lines.each do |line|
      next if line.length.zero?

      if line.start_with?(/1\.\s/)
        current_recipe[:name] = line.sub("1. ", "").strip
      elsif line.start_with?(/-\s/)
        current_recipe[:ingredients] << line.sub("- ", "").strip
      elsif line.start_with?(/2\.\s/)
        current_recipe[:instructions] << line.sub("2. ", "").strip
      end
    end

    @name = current_recipe[:name]
    @ingredients = current_recipe[:ingredients]
    @instructions = current_recipe[:instructions]
  end
end
