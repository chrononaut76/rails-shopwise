class StoreItemsController < ApplicationController
  def index
    @store_items = policy_scope(StoreItem)
  end

  private

  def fetch_prices(*terms)
    stores_queries = {
      iga: {
        query: 'https://www.iga.net/en/search?k=',
        selector: '.price'
      },
      metro: {
        query: 'https://www.metro.ca/en/online-grocery/search?filter=',
        selector: 'span .price-update'
      },
      pa: {
        query: 'https://www.supermarchepa.com/search?q=',
        selector: 'div .grid-product-price'
      },
      provigo: {
        query: 'https://www.provigo.ca/search?search-bar=',
        selector: '.price__value .selling-price-list__item__price .selling-price-list__item__price--sale__value'
      }
    }
  end
end
