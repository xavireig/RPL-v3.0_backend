class AddTransferActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :transfer_activities do |t|
      t.belongs_to :league, foreign_key: true, null: false
      t.belongs_to :virtual_round, foreign_key: true, null: false
      t.integer :from_virtual_club_id
      t.integer :to_virtual_club_id
      t.belongs_to :virtual_footballer, foreign_key: true, null: false
      t.boolean :auction, default: false
      t.decimal :amount, default: 0
      t.timestamps
    end

    add_foreign_key :transfer_activities, :virtual_clubs, column: :from_virtual_club_id
    add_foreign_key :transfer_activities, :virtual_clubs, column: :to_virtual_club_id
  end
end
