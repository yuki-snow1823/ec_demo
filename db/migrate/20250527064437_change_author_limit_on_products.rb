class ChangeAuthorLimitOnProducts < ActiveRecord::Migration[8.0]
  def up
    change_column :products, :author, :string, limit: 100
  end

  def down
    change_column :products, :author, :string
  end
end
