class UserItemsController < ApplicationController
  def index
    @user_items = policy_scope(UserItem)
    @items = policy_scope(Item)

    @items = Item.search_by_name(params[:query]) if params[:query].present?
    @stores = policy_scope(Store)
    @item_ids = @user_items.map(&:item_id)

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


end







# def calculate_total_price(store_prices)
#   total_price = 0
#   product.each do |item|
#     total_price += store_prices[item]
#   end
#   total_price
# end





# store_prices = { apple: 2, banana: 1, orange: 1.5 }

# total_price = calculate_total_price(product, store_prices)
# puts "Total price: $#{total_price}"
