class StoresController < ApplicationController
  def results
    @item_ids = params[:list]
    totals = {}
    Store.all.each do |store|
      store_items = StoreItem.where(item_id: @item_ids, store_id: store.id)
      totals[store.name] = store_items.map(&:price).sum
    end

    @stores = if params[:latitude].present? && params[:longitude].present?
                Store.nearby(params[:latitude], params[:longitude])
              else
                Store.all
              end

    @total_by_store = totals.map do |name, sum|
      { store: name, total_price: sum }
    end
    @total_by_store.sort_by! { |hash| hash[:total_price] }
    authorize @stores
  end
end
