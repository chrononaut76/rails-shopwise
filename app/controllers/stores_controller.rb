class StoresController < ApplicationController

  def compare_prices
    @list = list_params
    raise
  end

  def results
    @list = list_params
    raise

    @stores = if params[:latitude].present? && params[:longitude].present?
                Store.nearby(params[:latitude], params[:longitude])
              else
                Store.all
              end

    @stores_with_prices = @stores.includes(:store_items).map do |store|
      total_price = store.store_items.sum(:price)
      { store: store, total_price: total_price }
    end
    # @stores_with_prices.sort-by!(&:price)
    authorize @stores
  end

private

  def list_params
    params.require(:list).permit(:item_id, :user_id, :id)
    end
end
