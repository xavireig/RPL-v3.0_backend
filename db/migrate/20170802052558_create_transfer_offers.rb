class CreateTransferOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfer_offers do |t|
      t.integer :sender_virtual_club_id, foreign_key: true, null: false
      t.integer :receiver_virtual_club_id, foreign_key: true, null: false
      t.integer :status, default: 0, null: false
      t.string :message
      t.float :amount
      t.timestamps
    end
  end
end
