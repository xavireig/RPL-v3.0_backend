# frozen_string_literal: true

class CreateStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :statistics do |t|
      t.belongs_to :fixture, foreign_key: true, null: false
      t.belongs_to :footballer, foreign_key: true, null: false
      t.integer :accurate_pass, default: 0, null: false
      t.integer :total_final_third_passes, default: 0, null: false
      t.integer :attempts_conceded_ibox, default: 0, null: false
      t.integer :touches, default: 0, null: false
      t.integer :total_fwd_zone_pass, default: 0, null: false
      t.integer :accurate_fwd_zone_pass, default: 0, null: false
      t.integer :ontarget_scoring_att, default: 0, null: false
      t.integer :lost_corners, default: 0, null: false
      t.integer :goals_conceded, default: 0, null: false
      t.integer :goals, default: 0, null: false
      t.integer :own_goal, default: 0, null: false
      t.integer :mins_played, default: 0, null: false
      t.integer :ontarget_att_assist, default: 0, null: false
      t.integer :goal_assist, default: 0, null: false
      t.integer :total_pass, default: 0, null: false
      t.integer :won_contest, default: 0, null: false
      t.integer :interception, default: 0, null: false
      t.integer :turnover, default: 0, null: false
      t.integer :clean_sheet, default: 0, null: false
      t.integer :saves, default: 0, null: false
      t.integer :yellow_card, default: 0, null: false
      t.integer :red_card, default: 0, null: false
      t.integer :won_corners, default: 0, null: false
      t.integer :big_chance_missed, default: 0, null: false
      t.integer :penalty_save, default: 0, null: false
      t.integer :penalty_miss, default: 0, null: false
      t.integer :penalty_conceded, default: 0, null: false
      t.integer :penalty_won, default: 0, null: false
      t.integer :error_lead_to_goal, default: 0, null: false
      t.integer :assist_own_goal, default: 0, null: false
      t.integer :assist_handball_won, default: 0, null: false
      t.integer :assist_penalty_won, default: 0, null: false
      t.integer :assist_post, default: 0, null: false
      t.integer :assist_attempt_saved, default: 0, null: false
      t.integer :assist_blocked_shot, default: 0, null: false
      t.integer :assist_pass_lost, default: 0, null: false
      t.integer :won_tackle, default: 0, null: false
      t.jsonb :full, null: false, default: '{}'
      t.timestamps
    end
  end
end
