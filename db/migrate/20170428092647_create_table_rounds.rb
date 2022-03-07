class CreateTableRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :number
      t.belongs_to :season, foreign_key: true, null: false
    end

    add_index :rounds, %i[number season_id], unique: true
  end
end
