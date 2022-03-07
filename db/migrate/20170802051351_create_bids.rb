class CreateBids < ActiveRecord::Migration[5.1]
  def change
    create_table :bids do |t|
      t.integer :auction_id, foreign_key: true, null: false
      t.integer :bidder_virtual_club_id,
        foreign_key: true,
        null: false
      t.integer :status, default: 0, null: false
      t.float :amount, null: false
      t.timestamps
    end
  end
end
