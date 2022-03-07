# frozen_string_literal: true

# lineup representer
class CategoryResultRepresenter < Representable::Decorator
  include Representable::JSON
  property :goal, as: :cat_goals
  property :saves, as: :cat_save
  property :assists, as: :cat_assist
  property :take_ons, as: :cat_take_ons
  property :turnovers, as: :cat_turn_over
  property :discipline, as: :out_discipline
  property :key_passes, as: :cat_k_pass
  property :net_passes, as: :cat_net_pass
  property :possession, as: :cat_possession
  property :tackles_won, as: :cat_tackles
  property :clean_sheets, as: :out_clean_sheet
  property :pass_percent, as: :out_pass_pers
  property :interceptions, as: :cat_interceptions
  property :saves_percent, as: :out_save_percent
  property :goals_conceded, as: :out_gls_conc
  property :minutes_played, as: :out_minutes
  property :pass_completed, as: :cat_pass_completed
  property :shots_on_target, as: :cat_shot_on_target
  property :tackle_interception, as: :cat_tackle_interception
  property :goals_conceded_points, as: :cat_goals_conceded_points
  property :minutes_played_points, as: :cat_minutes_played_points
end
