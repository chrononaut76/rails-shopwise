class StoreItem < ApplicationRecord
  belongs_to :store
  belongs_to :item
end
