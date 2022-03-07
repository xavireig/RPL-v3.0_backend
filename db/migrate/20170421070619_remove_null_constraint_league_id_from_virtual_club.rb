class RemoveNullConstraintLeagueIdFromVirtualClub < ActiveRecord::Migration[5.0]
  def change
    change_column :virtual_clubs, :league_id, :integer, null: true
  end
end
