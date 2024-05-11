class Store < ApplicationRecord
  has_many :store_items

  validates :name, presence: true
  validates :address, presence: true
  validates :image_url, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
