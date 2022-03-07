class RemoveDirectAddDrops < ActiveRecord::Migration[5.1]
  def up
    drop_table :direct_add_drops
  end

  def down
    create_table :direct_add_drops do |t|
      t.integer :virtual_club_id, foreign_key: true, null: false
      t.integer :virtual_footballer_id, foreign_key: true, null: false
      t.integer :transfer_type, default: 0, null: false
    end
  end
end
