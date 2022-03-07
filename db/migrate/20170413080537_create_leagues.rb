# frozen_string_literal: true

class CreateLeagues < ActiveRecord::Migration[5.0]
  def change
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
        goal_conceled: -1.0,
        clean_sheet: 5.0,
        save: 0.0,
        defensive_error: -1.0,
        own_goal: -2.0,
        cross: 0.0,
        tackle_won: 0.5,
        interception: 0.0,
        penalty_messed: -1.0,
        penalty_saved: 0.0,
        big_chance_missed: 0.0,
        turn_over: 0.0,
        manager_win: 0.0,
        corner_kick_won: 0.0,
        penalty_won: 1.0,
        penalty_conceded: -1.0,
        key_pass: 1.0,
        net_pass: 1.0
    }

    point_scoring_for_all_position = {
        defender: point_scoring_default_settings,
        forward: point_scoring_default_settings,
        goalkeeper: point_scoring_default_settings,
        midfielder: point_scoring_default_settings,
    }

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

      clean_sheets: 1,
      clean_sheets_enabled: true,

      minutes_played: 1,
      minutes_played_enabled: true,

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
      interceptions_enabled: true

    }


    create_table :leagues do |t|
      t.integer :starting_round, null: false
      t.integer :required_teams, null: false
      t.integer :match_numbers, null: false
      t.belongs_to :season, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.datetime :waiver_auction_day
      t.string :invite_code, unique: true, null: false
      t.string :title, null: false
      t.integer :max_add_per_season, default: 12
      t.integer :max_add_per_week, default: 2
      t.integer :transfer_budget, default: 100
      t.boolean :chairman_veto, default: false
      t.string :scoring_type, null: false, default: 'category'
      t.boolean :double_gameweeks, default: false
      t.jsonb :category_scoring_settings,
        null: false,
        default: category_scoring_default_settings

      t.jsonb :point_scoring_settings,
        null: false,
        default: point_scoring_for_all_position

      t.datetime :waiver_auction_process_date
      t.boolean :auto_sub_enabled, default: false
      t.integer :min_fee_per_addition, default: 10
      t.string :draft_status, default: 'pending', null: false
      t.datetime :draft_time
      t.boolean :custom_draft_order, default: false
      t.string :time_per_pick_unit, default: 'seconds'
      t.integer :time_per_pick, default: 10

      t.timestamps
    end

    execute <<-SQL
      ALTER TABLE leagues
      add constraint check_draft_status check (draft_status in (
           'pending',
           'running',
           'completed'
         ));
    SQL

    execute <<-SQL
      ALTER TABLE leagues
      add constraint check_scoring_type check (scoring_type in (
           'point',
           'category'
         ));
    SQL
  end
end
