# frozen_string_literal: true

class League < ApplicationRecord
  # to show league information
  class SyncCategorySettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
    end

    step Model(::League, :find_by)
    step :league_drafted?
    failure :cannot_change_scoring_type, fail_fast: true
    step :generate_category!
    step Contract::Build()
    step Contract::Persist()

    private

    def league_drafted?(options)
      options['model'].draft_status.eql?('completed') ? false : true
    end

    def cannot_change_scoring_type(options)
      options['message'] =
        'You cannot change scoring type after league has drafted!'
    end

    def generate_category!(options, params:, **)
      new_category_settings = {}
      category_settings = params[:league_sco_cat]
      category_properties = category_mapper
      category_properties.merge!(
        extend_properties(category_properties)
      )
      category_settings.keys.each do |property|
        new_category_settings[category_properties.key(property.to_sym)] =
          category_settings[property]
      end
      options['model'].category_scoring_settings = new_category_settings
    end

    def extend_properties(category_properties)
      properties = {}
      category_properties.keys.each do |key|
        value = category_properties[key]
        properties[(key.to_s + '_enabled').to_sym] =
          ('is_' + value.to_s).to_sym
      end
      properties
    end

    def category_mapper
      value = {
        goal: :c_goal,
        assists: :c_assist,
        pass_completed: :c_pass_completed,
        pass_percent: :c_pass_percent,
        discipline: :c_discipline,
        goals_conceded: :c_goal_conceled,
        clean_sheets: :c_clean_sheet,
        minutes_played: :c_minutes,
        key_passes: :c_k_pass,
        tackles_won: :c_tackles,
        balls_won: :balls_won,
        turnovers: :c_turn_over,
        saves: :c_save,
        saves_percent: :c_save_percent,
        net_passes: :c_net_pass,
        interceptions: :c_interceptions,
        shots_on_target: :c_shots_on_target,
        take_ons: :c_take_ons,
        tackle_interception: :c_tackle_interception,
        possession: :c_possession,
        goals_conceded_points: :c_goals_conceded_points,
        minutes_played_points: :c_minutes_played_points
      }
      value
    end
  end
end
