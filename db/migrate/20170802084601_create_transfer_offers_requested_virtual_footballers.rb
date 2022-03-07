class CreateTransferOffersRequestedVirtualFootballers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfer_offers_requested_virtual_footballers do |t|
      t.integer :transfer_offer_id, foreign_key: true, null: false
      t.integer :virtual_footballer_id, foreign_key: true, null: false
    end
    add_index :transfer_offers_requested_virtual_footballers,
              %i[transfer_offer_id virtual_footballer_id],
              unique: true, name: 'index_on_to_rvf'
  end
end
