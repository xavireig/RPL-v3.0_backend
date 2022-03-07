class AddPreviousRoundIdToRounds < ActiveRecord::Migration[5.0]
  def change
    add_reference :rounds, :parent, foreign_key: { to_table: :rounds }
  end
end
