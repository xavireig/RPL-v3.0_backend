class ChangeColumnOwnGoalToOwnGoalsTableStatistics < ActiveRecord::Migration[5.0]
  def change
    rename_column :statistics, :own_goal, :own_goals
  end
end
