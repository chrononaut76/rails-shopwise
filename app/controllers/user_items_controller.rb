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

  private

  def query_api
    url = "https://api.edamam.com/api/food-database/v2/parser?app_id=#{ENV.fetch('EDAMAM_API_ID')}&app_key=#{ENV.fetch('EDAMAM_API_KEY')}&ingr=#{params[:query]}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['hints'].each do |item|
      Item.create!({ name: item.dig('food', 'knownAs') }) unless Item.find_by(food_id: item.dig('food', 'foodId'))
    end
  end
end
