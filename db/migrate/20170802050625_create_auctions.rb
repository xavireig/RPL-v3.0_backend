class CreateAuctions < ActiveRecord::Migration[5.1]
  def change
    create_table :auctions do |t|
      t.integer :virtual_footballer_id, foreign_key: true, null: false
      t.integer :virtual_round_id, foreign_key: true, null: false
      t.boolean :processed, default: false
      t.timestamps
    end
    add_index :auctions, %i[virtual_footballer_id virtual_round_id],
      unique: true
  end
end
