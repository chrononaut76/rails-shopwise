class UserItemsController < ApplicationController
  # before_action :set_item, only: %i[new create]

  def index
    @user_items = policy_scope(UserItem)
  end

  def create
    @item = Item.find(params[:item_id])
    @user_item = UserItem.new(user_item_params)
    # TODO: Define @user_item.item = item ?
    @user_item.user = current_user
    authorize @user_item
    @user_item.item = @item
    @user_item.save!
  end

  def destroy
    authorize @user_item
  end

  private

  # def set_item
  #   @item = Item.find(params[:item_id])
  # end

  def item_params
    params.require(:item).permit(:name)
  end

  def user_item_params
    params.require(:user_item).permit(:user_id, :item_id) # TODO: Identify required params
  end
end
