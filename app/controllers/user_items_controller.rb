class UserItemsController < ApplicationController
  # before_action :set_item, only: %i[new create]

  def index
    @user_items = policy_scope(UserItem)
    @items = policy_scope(Item)

    @items = @items.where('name ILIKE ?', "%#{params[:query]}%") if params[:query].present?

    respond_to do |format|
      format.html
      format.text { render partial: 'items/index', locals: { items: @items }, formats: [:html] }
    end
  end

  def create

    @item = Item.new(user_item_params)
    @item.save!
    @user_item = UserItem.new
    @user_item.user = current_user
    @user_item.item = @item
    authorize @user_item
    if @user_item.save
      redirect_to my_items_path, notice: 'Item added successfully.'
    end
  end

  def destroy
    @user_item = UserItem.find(params[:id])
    authorize @user_item
    @user_item.destroy
    redirect_to my_items_path
  end

  private

  # def set_item
  #   @item = Item.find(params[:item_id])
  # end

  def user_item_params
    params.require("/user_items").permit("/user_items", :name) # TODO: Identify required params
  end
end
