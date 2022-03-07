class AddExtraCategoryPointsToLeagueTable < ActiveRecord::Migration[5.0]
  def up
    category_scoring_default_settings = {
      goal: 2,
      goal_enabled: true,

      assists: 1,
      assists_enabled: false,

      pass_completed: 0,
      pass_completed_enabled: true,

      pass_percent: 1,
      pass_percent_enabled: false,

      discipline: 1,
      discipline_enabled: true,

      goals_conceded: 1,
      goals_conceded_enabled: true,

      goals_conceded_points: 1,
      goals_conceded_points_enabled: false,

      clean_sheets: 1,
      clean_sheets_enabled: true,

      minutes_played: 1,
      minutes_played_enabled: false,

      minutes_played_points: 1,
      minutes_played_points_enabled: true,

      key_passes: 1,
      key_passes_enabled: true,

      tackles_won: 1,
      tackles_won_enabled: true,

      turnovers: 1,
      turnovers_enabled: false,

      saves: 1,
      saves_enabled: false,

      saves_percent: 1,
      saves_percent_enabled: true,

      net_passes: 1,
      net_passes_enabled: true,

      interceptions: 1,
      interceptions_enabled: false,

      shots_on_target: 1,
      shots_on_target_enabled: false,

      take_ons: 1,
      take_ons_enabled: false,

      tackle_interception: 1,
      tackle_interception_enabled: false,

      possession: 1,
      possession_enabled: false
    }

    change_column :leagues,
      :category_scoring_settings,
      :jsonb,
      default: category_scoring_default_settings
  end

  def down
    category_scoring_default_settings = {
      goal: 2,
      goal_enabled: true,

      assists: 1,
      assists_enabled: true,

      pass_completed: 0,
      pass_completed_enabled: true,

      pass_percent: 1,
      pass_percent_enabled: true,

      discipline: 1,
      discipline_enabled: true,

      goals_conceded: 1,
      goals_conceded_enabled: true,

      goals_conceded_points: 1,
      goals_conceded_points_enabled: true,

      clean_sheets: 1,
      clean_sheets_enabled: true,

      minutes_played: 1,
      minutes_played_enabled: true,

      minutes_played_points: 1,
      minutes_played_points_enabled: true,

      key_passes: 1,
      key_passes_enabled: true,

      tackles_won: 1,
      tackles_won_enabled: true,

      turnovers: 1,
      turnovers_enabled: true,

      saves: 1,
      saves_enabled: true,

      saves_percent: 1,
      saves_percent_enabled: true,

      net_passes: 1,
      net_passes_enabled: true,

      interceptions: 1,
      interceptions_enabled: true,

      shots_on_target: 1,
      shots_on_target_enabled: true,

      take_ons: 1,
      take_ons_enabled: true,

      tackle_interception: 1,
      tackle_interception_enabled: true,

      possession: 1,
      possession_enabled: true,
    }

    change_column :leagues,
      :category_scoring_settings,
      :jsonb,
      default: category_scoring_default_settings
  end
end
