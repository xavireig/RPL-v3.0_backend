class CreatePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :positions do |t|
      t.integer :footballer_id, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
