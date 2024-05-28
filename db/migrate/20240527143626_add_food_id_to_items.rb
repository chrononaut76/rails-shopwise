class AddFoodIdToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :food_id, :string
  end
end
