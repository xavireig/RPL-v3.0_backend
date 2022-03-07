class CreateDraftHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :draft_histories do |t|
      t.integer :iteration, null: false
      t.integer :step, null: false
      t.belongs_to :league, foreign_key: true, null: false
      t.belongs_to :virtual_club, foreign_key: true, null: false
      t.belongs_to :virtual_footballer, foreign_key: true
      t.timestamps
    end
  end
end
