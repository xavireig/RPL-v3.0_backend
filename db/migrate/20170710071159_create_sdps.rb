class CreateSdps < ActiveRecord::Migration[5.0]
  def change
    create_table :sdps do |t|
      t.integer :amount, default: 0
      t.belongs_to :footballer, foreign_key: true, null: false
      t.belongs_to :season, foreign_key: true, null: false
    end

    add_index :sdps, %i[footballer_id season_id], unique: true
  end
end
