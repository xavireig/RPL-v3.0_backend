# frozen_string_literal: true

# statistic representer
class StatisticRepresenter < Representable::Decorator
  include Representable::JSON

  property :accurate_pass, as: :int_accurate_pass
  property :goals_conceded, as: :out_gls_conc
  property :goals_conceded, as: :int_team_goal_conceded
  property :goals, as: :int_goals
  property :goals, as: :out_goals
  property :own_goals, as: :int_own_goals
  property :mins_played, as: :int_minutes
  property :mins_played, as: :out_minutes
  property :total_pass, as: :int_total_passes
  property :total_pass, as: :int_total_pass_add
  property :interception, as: :int_interception
  property :turnover, as: :int_turnover
  property :clean_sheet, as: :int_clean_sheet
  property :clean_sheet, as: :out_clean_sheet
  property :saves, as: :int_save
  property :yellow_card, as: :int_yellow_cards
  property :red_card, as: :int_red_cards
  property :won_corners, as: :int_won_corners
  property :big_chance_missed, as: :int_big_chance_missed
  property :penalty_save, as: :int_penalty_save
  property :penalty_miss, as: :int_penalty_missed
  property :penalty_conceded, as: :int_penalty_conceded
  property :penalty_won, as: :int_penalty_won
  property :won_tackle, as: :int_won_tackle
  property :out_net_pass, exec_context: :decorator
  property :out_kpass, exec_context: :decorator
  property :goal_assist, as: :int_assists
  property :out_pass_pers, exec_context: :decorator
  property :out_discipline, exec_context: :decorator
  property :out_save_percent, exec_context: :decorator
  property :ontarget_scoring_att, as: :int_ontarget_scoring_att
  property :sub_on, as: :is_sub_on
  property :sub_off, as: :is_sub_off
  property :cat_goals_conceded_points
  property :ontarget_att_assist
  property :won_contest, as: :int_take_ons
  property :error_lead_to_goal
  property :assist_own_goal
  property :assist_handball_won
  property :assist_penalty_won
  property :assist_post
  property :assist_attempt_saved
  property :assist_blocked_shot
  property :assist_pass_lost
  property :total_final_third_passes
  property :attempts_conceded_ibox
  property :touches
  property :total_fwd_zone_pass
  property :accurate_fwd_zone_pass
  property :lost_corners

  def out_net_pass
    (represented.accurate_pass * 2) - represented.total_pass
  end

  def out_kpass
    represented.ontarget_att_assist - represented.goal_assist
  end

  def out_pass_pers
    if represented.total_pass == 0
      0
    else
      represented.accurate_pass / represented.total_pass
    end
  end

  def out_discipline
    (represented.yellow_card * -2) + (represented.red_card * -5)
  end

  def out_save_percent
    if represented.goals_conceded == 0
      0
    else
      represented.saves / represented.goals_conceded
    end
  end
end
