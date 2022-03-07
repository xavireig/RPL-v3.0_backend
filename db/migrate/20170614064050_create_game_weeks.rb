class CreateGameWeeks < ActiveRecord::Migration[5.0]
  def change
    create_table :game_weeks do |t|
      t.belongs_to :virtual_club, foreign_key: true, null: false
      t.belongs_to :round, foreign_key: true, null: false
      t.timestamps
    end
  end
end
