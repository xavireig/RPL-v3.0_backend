class CreatePreferredFootballers < ActiveRecord::Migration[5.0]
  def change
    create_table :preferred_footballers do |t|
      t.belongs_to :virtual_club, foreign_key: true, null: false
      t.belongs_to :virtual_footballer, foreign_key: true, null: false
      t.integer :position
      t.timestamps
    end
  end
end
