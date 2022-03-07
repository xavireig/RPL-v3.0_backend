class ChangeAdminDatatypeInUsers < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :users, :admin
    add_column :users, :admin, :integer, default: false, null: false
  end
  def self.down
    remove_column :users, :admin
    add_column :users, :admin, :string, default: false, null: false
  end
end
