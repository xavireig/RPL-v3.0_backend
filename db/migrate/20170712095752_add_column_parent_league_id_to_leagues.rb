class AddColumnParentLeagueIdToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :parent_league_id, :integer, index: true
  end
end
