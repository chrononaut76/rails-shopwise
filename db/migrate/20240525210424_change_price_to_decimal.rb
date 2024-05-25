class ChangePriceToDecimal < ActiveRecord::Migration[7.1]
  def change
    change_column :store_items, :price, :decimal, precision: 5, scale: 2
  end
end
