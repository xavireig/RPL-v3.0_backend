class RemoveLastOnlineFromUsers < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :last_online
  end

  def down
    add_column :users, :last_online, :datetime
  end
end
