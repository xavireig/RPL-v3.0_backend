class CreateVirtualFixtures < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_fixtures do |t|
      t.belongs_to :virtual_round, foreign_key: true, null: false
      t.integer :home_virtual_club_id, null: false
      t.integer :away_virtual_club_id, null: false
      t.timestamps
    end

    add_foreign_key :virtual_fixtures, :virtual_clubs, column: :home_virtual_club_id
    add_foreign_key :virtual_fixtures, :virtual_clubs, column: :away_virtual_club_id
  end
end
