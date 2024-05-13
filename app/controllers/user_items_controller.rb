class UserItemsController < ApplicationController
  def index
    @user_items = policy_scope(UserItem)
  end

  def create
    @user_item = UserItem.new(user_item_params)
    # @user_item.item = item ?
    @user_item.user = current_user
    authorize @user_item
  end

  def destroy
    authorize @user_item
  end

  private

  def user_item_params

  end
end
