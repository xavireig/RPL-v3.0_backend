class CreateVirtualRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_rounds do |t|
      t.belongs_to :league, foreign_key: true, null: false
      t.belongs_to :round, foreign_key: true, null: false
      t.timestamps
    end
  end
end
