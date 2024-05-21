class UserItemsController < ApplicationController
  def index
    @user_items = policy_scope(UserItem)
    @items = policy_scope(Item)

    @items = Item.search_by_name(params[:query]) if params[:query].present?

    respond_to do |format|
      format.html
      format.text { render partial: 'items/index', locals: { items: @items }, formats: [:html] }
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
