class UserItemsController < ApplicationController
  def index
    @user_items = policy_scope(UserItem)
  end

  def create
    @user_item = UserItem.new(user_item_params)
    # TODO: Define @user_item.item = item ?
    @user_item.user = current_user
    authorize @user_item
  end

  def destroy
    authorize @user_item
  end

  private

  def user_item_params
    params.require(:user_item).permit(:name) # TODO: Identify required params
  end
end
