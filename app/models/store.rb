class Store < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_many :store_items
  has_many :items, through: :store_items

  validates :name, :address, :image_url, :latitude, :longitude, presence: true

  # def self.nearby(latitude, longitude, distance_in_kms = 50)
  def self.nearby(latitude, longitude, distance_in_kms)
    near([latitude, longitude], distance_in_kms, units: :km)
  end
end
