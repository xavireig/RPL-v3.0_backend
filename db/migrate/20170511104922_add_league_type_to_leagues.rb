class AddLeagueTypeToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :league_type, :string, default: 'private', null: false
  end
end
