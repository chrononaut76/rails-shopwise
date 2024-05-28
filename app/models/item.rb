class Item < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name,
    against: :name,
    using: {
      tsearch: { prefix: true }
    }
  has_many :user_items
  has_many :users, through: :user_items

  has_many :store_items
  has_many :stores, through: :store_items

  validates :name, presence: true
  validates :food_id, presence: true, uniqueness: true
end
