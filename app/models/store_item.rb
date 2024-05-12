class StoreItem < ApplicationRecord
  belongs_to :store
  belongs_to :item

  validates :price, presence: true
  validates :store_id, presence: true
  validates :item_id, presence: true
end
