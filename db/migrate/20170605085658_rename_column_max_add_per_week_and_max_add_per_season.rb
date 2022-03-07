class RenameColumnMaxAddPerWeekAndMaxAddPerSeason < ActiveRecord::Migration[5.0]
  def up
    rename_column :leagues, :max_add_per_week, :bonus_per_win
    rename_column :leagues, :max_add_per_season, :bonus_per_draw
    change_column :leagues, :bonus_per_win, :integer, default: 2
    change_column :leagues, :bonus_per_draw, :integer, default: 1
  end

  def down
    rename_column :leagues, :bonus_per_win, :max_add_per_week
    rename_column :leagues, :bonus_per_draw, :max_add_per_season
  end
end
