class StoresController < ApplicationController
  def results
    @item_ids = params[:list]
    totals = {}
    Store.all.each do |store|
      store_items = StoreItem.where(item_id: @item_ids, store_id: store.id)
      totals[store.name] = store_items.map(&:price).sum
    end

    @total_by_store = totals.map do |name, sum|
      { store: name, total_price: sum }
    end
    @total_by_store.sort_by! { |hash| hash[:total_price] }


    @stores = if params[:latitude].present? && params[:longitude].present?
                Store.nearby(params[:latitude], params[:longitude])
              else
                Store.all
              end
            @markers = @stores.geocoded.map do |store|
              store_total = @total_by_store.select{|h| h[:store] == store.name}.first.dig(:total_price)
                {
                  lat: store.latitude,
                  lng: store.longitude,
                  info_window_html: render_to_string(partial: "info_window", locals: {store: store, store_total: store_total}),
                  price_category: price_category(store_total)
                }
            end
    authorize @stores
  end

  private

  def price_category(store_total)
    if store_total == @total_by_store.first[:total_price]
      cheapest = store_total
    elsif store_total == @total_by_store.last[:total_price]
      expensive = store_total
    else
      mid_range = store_total
    end
    { cheapest: cheapest,
      expensive: expensive,
      mid_range: mid_range }
  end

  def exists?(value)
    value if value
  end
end
