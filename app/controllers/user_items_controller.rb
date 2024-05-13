class UserItemsController < ApplicationController

  def index
    @user_items = policy_scope(UserItem)
  end

  def create

  end

  def destroy

  end
end
