# frozen_string_literal: true

# stats representer
class StatsRepresenter < Representable::Decorator
  include Representable::JSON
  delegate :home_score, :away_score, :match_time, :now_play,
           :done?, :away_club, to: 'represented'
  property :int_minutes
  property :int_assists
  property :int_goals
  property :out_kpass
  property :int_team_goal_conceded
  property :int_own_goals
  property :int_clean_sheet
  property :int_interception
  property :int_accurate_pass
  property :int_total_pass_add
  property :int_save
  property :int_won_tackle
  property :int_turnover
  property :int_yellow_cards
  property :int_red_cards
  property :out_discipline
  property :int_big_chance_missed
  property :int_won_corners
  property :int_defensive_corners
  property :int_defensive_error
  property :int_penalty_conceded
  property :int_penalty_save
  property :int_penalty_won
  property :out_pass_pers
  property :out_net_pass
end