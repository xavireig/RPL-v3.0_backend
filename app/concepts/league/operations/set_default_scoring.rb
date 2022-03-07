# frozen_string_literal: true

class League < ApplicationRecord
  # invite member to join league
  class DefaultScoring < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
    end

    step Model(::League, :find_by)
    step :league_drafted?
    step :cannot_change_scoring_type, fail_fast: true
    step :default_scoring!
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    private

    def league_drafted?(options)
      options['model'].draft_status.eql?('completed') ? false : true
    end

    def cannot_change_scoring_type(options)
      options['message'] =
        'You cannot reset scoring settings after league has drafted!'
    end

    def default_scoring!(options)
      options['model'].category_scoring_settings =
        SCORING_DEFAULT['category_settings']

      default_point = SCORING_DEFAULT['point_settings']
      default_point_settings = {
        defender: default_point.dup,
        forward: default_point.dup,
        goalkeeper: default_point.dup,
        midfielder: default_point.dup
      }
      default_point_settings =
        assign_custom_value default_point_settings

      options['model'].point_scoring_settings =
        default_point_settings
    end

    def assign_custom_value(default_point_settings)
      # forward
      default_point_settings[:forward][:goal] = 5
      default_point_settings[:forward][:goal_conceded] = 0
      default_point_settings[:forward][:clean_sheet] = 0

      # midfielder
      default_point_settings[:midfielder][:goal] = 5
      default_point_settings[:midfielder][:clean_sheet] = 1
      default_point_settings[:midfielder][:goal_conceded] = -0.5

      # goalkeeper
      default_point_settings[:goalkeeper][:save] = 0.5
      default_point_settings[:goalkeeper][:penalty_saved] = 2
      default_point_settings
    end
  end
end
