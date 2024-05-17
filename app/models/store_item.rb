class StoreItem < ApplicationRecord
  belongs_to :store
  belongs_to :item

  validates :price, :store_id, :item_id, presence: true
end
