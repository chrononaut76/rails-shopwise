class AddPriceToStoreItems < ActiveRecord::Migration[7.1]
  def change
    add_column :store_items, :price, :integer
  end
end
