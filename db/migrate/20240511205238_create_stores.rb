class CreateStores < ActiveRecord::Migration[7.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.text :address
      t.string :image_url
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
