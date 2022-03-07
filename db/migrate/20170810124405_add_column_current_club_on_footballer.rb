class AddColumnCurrentClubOnFootballer < ActiveRecord::Migration[5.1]
  def change
    add_column :footballers, :current_club_id, :integer, foreign_key: true
  end
end
