class AddColumnFantasyAssistAndWeightGoalsCategoryToLeague < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :fantasy_assist, :boolean, default: true
    add_column :leagues, :weight_goals_category, :boolean, default: false
  end
end

