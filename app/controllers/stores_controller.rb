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
    @total_by_store.each.with_index{|h, i| h[:category] = categorize(i) }

    @stores = if params[:latitude].present? && params[:longitude].present?
      Store.nearby(params[:latitude], params[:longitude])
    else
      Store.all
    end
    @markers = @stores.geocoded.map do |store|
      store_total = @total_by_store.select{|h| h[:store] == store.name}.first.dig(:total_price)
      price_category = @total_by_store.select{|h| h[:store] == store.name}.first.dig(:category)
      {
        lat: store.latitude,
        lng: store.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {store: store, store_total: store_total, price_category: price_category}),
      }
    end
    authorize @stores
  end

  def categorize(index)
    case index
    when 0..2
      :cheapest
    when 3..5
      :affordable
    when 6..100
      :expensive
    end
  end
end
