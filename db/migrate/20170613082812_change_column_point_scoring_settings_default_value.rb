class ChangeColumnPointScoringSettingsDefaultValue < ActiveRecord::Migration[5.0]
  def up
    point_scoring_default_settings = {
      goal: 6.0,
      assist: 3.0,
      chance_created: 0.0,
      pass_completed: 0.0,
      played_30_min: 1.0,
      played_50_min: 2.0,
      played_90_min: 3.0,
      yellow_cards: -2.0,
      red_cards: -5.0,
      goal_conceded: -1.0,
      clean_sheet: 5.0,
      save: 0.0,
      defensive_error: -1.0,
      own_goal: -2.0,
      cross: 0.0,
      tackle_won: 0.5,
      interception: 0.0,
      penalty_missed: -2.0,
      penalty_saved: 0.0,
      big_chance_missed: 0.0,
      turn_over: 0.0,
      manager_win: 0.0,
      corner_kick_won: 0.0,
      penalty_won: 0.0,
      penalty_conceded: -1.0,
      key_pass: 1.0,
      net_pass: 1.0,
      shot_on_target: 0,
      passes_40: 1,
      passes_50: 2,
      passes_60: 3,
      take_ons: 0
    }

    point_scoring_for_all_position = {
        defender: point_scoring_default_settings.dup,
        forward: point_scoring_default_settings.dup,
        goalkeeper: point_scoring_default_settings.dup,
        midfielder: point_scoring_default_settings.dup
    }

    # forward
    point_scoring_for_all_position[:forward][:goal] = 5
    point_scoring_for_all_position[:forward][:goal_conceded] = 0
    point_scoring_for_all_position[:forward][:clean_sheet] = 0

    # midfielder
    point_scoring_for_all_position[:midfielder][:goal] = 5
    point_scoring_for_all_position[:midfielder][:clean_sheet] = 1
    point_scoring_for_all_position[:midfielder][:goal_conceded] = -0.5

    # goalkeeper
    point_scoring_for_all_position[:goalkeeper][:save] = 0.5
    point_scoring_for_all_position[:goalkeeper][:penalty_saved] = 2

    change_column :leagues,
      :point_scoring_settings,
      :jsonb,
      default: point_scoring_for_all_position
  end

  def down
    point_scoring_default_settings = {
      goal: 6.0,
      assist: 3.0,
      chance_created: 0.0,
      pass_completed: 0.0,
      played_30_min: 1.0,
      played_50_min: 2.0,
      played_90_min: 3.0,
      yellow_cards: -2.0,
      red_cards: -5.0,
      goal_conceded: -1.0,
      clean_sheet: 5.0,
      save: 0.0,
      defensive_error: -1.0,
      own_goal: -2.0,
      cross: 0.0,
      tackle_won: 0.5,
      interception: 0.0,
      penalty_missed: -1.0,
      penalty_saved: 0.0,
      big_chance_missed: 0.0,
      turn_over: 0.0,
      manager_win: 0.0,
      corner_kick_won: 0.0,
      penalty_won: 1.0,
      penalty_conceded: -1.0,
      key_pass: 1.0,
      net_pass: 1.0,
      shot_on_target: 0,
      penalty_missed: -1,
      passes_40: 1,
      passes_50: 2,
      passes_60: 3,
      take_ons: 0
    }

    point_scoring_for_all_position = {
      defender: point_scoring_default_settings,
      forward: point_scoring_default_settings,
      goalkeeper: point_scoring_default_settings,
      midfielder: point_scoring_default_settings
    }

    change_column :leagues,
      :point_scoring_settings,
      :jsonb,
      default: point_scoring_for_all_position
  end
end
