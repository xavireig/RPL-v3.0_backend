class AddFormationToGameWeek < ActiveRecord::Migration[5.0]
  def change
    add_column :game_weeks, :formation_id, :integer, null: true, index: true
  end
end
