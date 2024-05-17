class StoresController < ApplicationController
  def results
    @stores = if params[:latitude].present? && params[:longitude].present?
                Store.nearby(params[:latitude], params[:longitude])
              else
                Store.all
              end

    @stores_with_prices = @stores.includes(:store_items).map do |store|
      total_price = store.store_items.sum(:price)
      { store: store, total_price: total_price }
    end
    authorize @stores
  end
end
