class CreateVirtualFootballers < ActiveRecord::Migration[5.0]
  def change
    create_table :virtual_footballers do |t|
      t.belongs_to :footballer, foreign_key: true, null: false
      t.belongs_to :league, foreign_key: true, null: false
      t.belongs_to :virtual_club, foreign_key: true, null: true
      t.timestamps
    end
  end
end
