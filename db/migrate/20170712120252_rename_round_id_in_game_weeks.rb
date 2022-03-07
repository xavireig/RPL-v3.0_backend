class RenameRoundIdInGameWeeks < ActiveRecord::Migration[5.0]
  def change
    remove_column :game_weeks, :round_id
    add_column :game_weeks, :virtual_round_id, :integer

    add_index :game_weeks, :virtual_round_id
    add_foreign_key :game_weeks, :virtual_rounds
  end
end
