class AddIndexToVirtualClub < ActiveRecord::Migration[5.0]
  def change
    add_index :virtual_clubs, [:user_id, :league_id], unique: true unless index_exists? :virtual_clubs, [:user_id, :league_id]
  end
end
