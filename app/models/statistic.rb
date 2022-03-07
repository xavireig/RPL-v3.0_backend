# frozen_string_literal: true

# Statistic Model
class Statistic < ApplicationRecord
  #
  # associations
  #

  belongs_to :fixture, touch: true
  belongs_to :footballer, touch: true

  #
  # class methods
  #

  # statistics select section that need
  # for calculation
  def self._select_column_sql
    <<-sql
      (SUM(goals)-SUM(own_goals)) as rpl_goals,
            SUM(mins_played) as rpl_mins,
            SUM(goal_assist) as rpl_goal_assists,
            SUM(goals_conceded) as rpl_goals_conceded,
            SUM(clean_sheet) as rpl_clean_sheet,
            SUM(ontarget_scoring_att) as rpl_ontarget_scoring_atts,
            SUM(ontarget_att_assist) as rpl_ontarget_att_assist,
            SUM(total_pass) as rpl_total_passes,
            SUM(accurate_pass) as rpl_accurate_passs,
            SUM(won_contest) as rpl_won_contests,
            SUM(yellow_card) as rpl_yellow_cards,
            SUM(red_card) as rpl_red_cards,
            SUM(won_tackle) as rpl_won_tackles,
            SUM(interception) as rpl_interceptions,
            SUM(turnover) as rpl_turnovers,
            SUM(penalty_save) as rpl_penalty_save,
            SUM(penalty_miss) as rpl_penalty_miss,
            SUM(big_chance_missed) as rpl_big_chance_missed,
            SUM(CASE
                 WHEN mins_played >=  90 THEN 3
                 WHEN mins_played >= 61 THEN 2
                 WHEN mins_played > 0 THEN 1
                 ELSE 0
              END) as rpl_points,
            SUM(saves) as rpl_saves
    sql
  end

  # build hash from select query that use
  # Statistic.stat_cal_sql method's sql
  def self.build_statistic(r)
    {
      goals: r.rpl_goals,
      mins_played: r.rpl_mins,
      points: r.rpl_points,
      goal_assist: r.rpl_goal_assists,
      # shots_on_target: r.ontarget_scoring_atts,
      total_pass: r.rpl_total_passes,
      accurate_pass: r.rpl_accurate_passs,
      take_ons: r.rpl_won_contests,
      yellow_card: r.rpl_yellow_cards,
      red_card: r.rpl_red_cards,
      tackles: r.rpl_won_tackles,
      interception: r.rpl_interceptions,
      turnover: r.rpl_turnovers,
      saves: r.rpl_saves,
      ontarget_att_assist: r.rpl_ontarget_att_assist,
      goals_conceded: r.rpl_goals_conceded,
      clean_sheet: r.rpl_clean_sheet,
      big_chance_missed: r.rpl_big_chance_missed,
      won_contest: r.rpl_won_contests
    }
  end

  #
  # methods for Category Scoring
  #

  alias_attribute :cat_total_pass, :total_pass
  alias_attribute :cat_accurate_pass, :accurate_pass
  # for saves percentage (Saves/Goal)
  alias_attribute :cat_saves_percent_goals_conceded, :goals_conceded

  def cat_goal
    goals - own_goals
  end

  def cat_saves
    saves
  end

  def cat_assists
    goal_assist
  end

  def cat_take_ons
    won_contest
  end

  def cat_turnovers
    turnover
  end

  def cat_discipline
    if second_yellow.zero?
      (yellow_card * -2) + (red_card * -5)
    else
      red_card * -5
    end
  end

  def cat_key_passes
    (goal_assist * 2) + ontarget_att_assist
  end

  def cat_net_passes
    (accurate_pass * 2) - total_pass
  end

  def cat_possession
    won_tackle + interception - turnover
  end

  def cat_tackles_won
    won_tackle
  end

  # only Goalkeeper & Defender's clean sheet be considered
  def cat_clean_sheets
    return 0 unless
      %w[Goalkeeper Defender].include?(footballer.position)

    clean_sheet
  end

  # Saves/Goal
  # this method is not using for actual calculation but
  # don't remove it ;)
  def cat_pass_percent; end

  def cat_pass_completed
    0
  end

  def cat_interceptions
    interception
  end

  # for saves percentage (Saves/Goal)
  def cat_saves_percent
    return 0 unless footballer.reload.position.eql?('Goalkeeper')
    case
      when clean_sheet == 1 then 10000000
      when goals_conceded == 0 || mins_played.zero? then 0
      else
        saves.to_f / goals_conceded
    end
  end

  def cat_minutes_played
    mins_played
  end

  def cat_shots_on_target
    ontarget_scoring_att
  end

  def cat_tackle_interception
    won_tackle + interception
  end

  def cat_goals_conceded_points
    return dnp_goals_conceded_points(footballer.position) if
      fixture.done? && mins_played.zero?

    case footballer.position
    when 'Midfielder' then mid_goals_conceded_points
    when 'Goalkeeper' then gk_def_goals_conceded_points
    when 'Defender' then gk_def_goals_conceded_points
    else
      0
    end
  end

  def cat_minutes_played_points
    case mins_played
    when 90..1000 then 3
    when 61..89 then 2
    when 1..60 then 1
    else 0
    end
  end

  def cat_goals_conceded
    return dnp_goals_conceded(footballer.position) if mins_played.zero?

    case footballer.position
      when 'Midfielder' then -0.5 * goals_conceded
      when 'Goalkeeper' then -1 * goals_conceded
      when 'Defender' then -1 * goals_conceded
      else
        0
    end
  end

  #
  # methods for Points Scoring
  #

  def points_goal
    goals
  end

  def points_interception
    interception
  end

  def points_take_ons
    won_contest
  end

  def points_assist
    goal_assist
  end

  def points_corner_kick_won
    won_corners
  end

  def points_penalty_missed
    penalty_miss
  end

  def points_penalty_saved
    penalty_save
  end

  def points_penalty_won
    penalty_won
  end

  def points_turn_over
    turnover
  end

  def points_clean_sheet
    clean_sheet
  end

  def points_goal_conceded
    goals_conceded
  end

  def points_defensive_error
    error_lead_to_goal
  end

  def points_tackle_won
    won_tackle
  end

  def points_penalty_conceded
    penalty_conceded
  end

  def points_shot_on_target
    ontarget_scoring_att - goals
  end

  def points_passes_40
    return 0 if points_passes_50 == 1 || points_passes_60 == 1

    (total_pass != 0 && accurate_pass >= 40 && (accurate_pass.to_f / total_pass) >= 0.8) ? 1 : 0
  end

  def points_passes_50
    return 0 if points_passes_60 == 1

    (total_pass != 0 && accurate_pass >= 50 && (accurate_pass.to_f / total_pass) >= 0.8) ? 1 : 0
  end

  def points_passes_60
    (total_pass != 0 && accurate_pass >= 60 && (accurate_pass.to_f / total_pass) >= 0.8) ? 1 : 0
  end

  # this represents 1 - 60 Min Played point scoring system
  def points_played_30_min
    mins_played <= 60 && mins_played > 0 ? 1 : 0
  end

  # this represents 61 - 89 Min Played point scoring system
  def points_played_50_min
    mins_played <= 89 && mins_played >= 61 ? 1 : 0
  end

  # this represents 90+ Min Played point scoring system
  def points_played_90_min
    mins_played >= 90 ? 1 : 0
  end

  def points_key_passes
    ontarget_att_assist - goal_assist
  end

  def points_save
    saves
  end

  def points_own_goal
    own_goals
  end

  def points_red_cards
    red_card
  end

  def points_yellow_cards
    yellow_card
  end

  def points_key_pass
    ontarget_att_assist - goal_assist
  end

  def points_big_chance_missed
    big_chance_missed
  end

  def sub_on
    full_stat['total_sub_on'].present?
  end

  def sub_of
    full_stat['total_sub_off'].present?
  end

  # TODO: need to delete from point scoring
  def points_net_pass
    0
  end

  def points_pass_completed
    0
  end

  def points_cross
    0
  end

  def points_chance_created
    0
  end

  def points_manager_win
    0
  end # end of delete section

  private

  def gk_def_goals_conceded_points
    case
    when clean_sheet == 1 then 3
    when goals_conceded == 1 then 1
    when goals_conceded == 2 then 0
    when goals_conceded == 3 then -1
    when goals_conceded >= 4 then -3
    else 0
    end
  end

  def mid_goals_conceded_points
    case
    when clean_sheet == 1 then 1
    when goals_conceded >= 4 then -1.0
    when goals_conceded == 3 then -0.5
    else 0
    end
  end

  def dnp_goals_conceded_points(position)
    case position
    when 'Midfielder' then -0.5
    when 'Goalkeeper' then -1
    when 'Defender' then -1
    else 0
    end
  end

  def dnp_goals_conceded(position)
    case position
    when 'Midfielder' then -1
    when 'Goalkeeper' then -2
    when 'Defender' then -2
    else 0
    end
  end
end
