class AddPreviousRoundIdToGameWeeks < ActiveRecord::Migration[5.0]
  def change
    add_reference :game_weeks, :parent, foreign_key: { to_table: :game_weeks }
  end
end
