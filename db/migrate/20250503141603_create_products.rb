class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.integer :stock
      t.boolean :active

      t.timestamps
    end
  end
end
