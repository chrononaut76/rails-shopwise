class StoreItemsController < ApplicationController
  def index
    @store_items = policy_scope(StoreItem)
  end
end
