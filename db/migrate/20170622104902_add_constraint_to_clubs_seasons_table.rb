class AddConstraintToClubsSeasonsTable < ActiveRecord::Migration[5.0]
  def change
    add_index :clubs_seasons, %i[club_id season_id], unique: true
  end
end
