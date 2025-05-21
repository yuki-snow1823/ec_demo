class ChangeAdminDefaultInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :admin, :boolean, default: false
  end
end
