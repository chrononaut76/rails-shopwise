class UserItemsController < ApplicationController
  def index
    @user_items = policy_scope(UserItem)
  end

  def create
    raise
    @item = Item.search_by_name(item_params)
    @user_item = UserItem.new
    @user_item.user = current_user
    @user_item.item = @item
    authorize @user_item
    @user_item.save!
  end

  def destroy
    authorize @user_item
  end

  private

  def item_params
    params.require(:item).permit(:name) # TODO: Identify required params
  end
end
