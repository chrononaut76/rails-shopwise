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
    number_of_stores = @total_by_store.length
    @total_by_store.each.with_index{|h, i| h[:category] = categorize(i, number_of_stores - 1) }

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
                  info_window_html: render_to_string(partial: "info_window", locals: { store: store, store_total: store_total, price_category: price_category}),
                  price_category: price_category,
                }
            end
    authorize @stores
  end


  def categorize(index, last_item)
    case index
    when 0
      "cheapest"
    when 1...last_item
      "affordable"
    when last_item
      "expensive"
    end
  end
end


private

  def price_category(store_total)
    if store_total == @total_by_store.first[:total_price]
      cheapest = store_total
    elsif store_total == @total_by_store.last[:total_price]
      expensive = store_total
    else
      affordable = store_total
    end
    { cheapest: cheapest,
      expensive: expensive,
      mid_range: affordable }
  end

  # def exists?(value)
  #   value if value
  # end
