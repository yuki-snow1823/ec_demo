class AddAuthorToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :author, :string
  end
end
