# frozen_string_literal: true

# league model
class League < ApplicationRecord
  # to show league information
  class SyncPointSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
    end

    step Model(::League, :find_by)
    step :league_drafted?
    failure :cannot_change_scoring_type, fail_fast: true
    step :generate_point_settings!
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

    def delete_unwanted_key!(position_point)
      position_point.delete(:id)
      position_point.delete(:league_id)
      position_point.delete(:position)
    end

    def generate_point_settings!(options, params:, **)
      new_point_settings = {}
      point_settings = params[:league_sco_points]
      point_properties = point_scoring_mapper

      point_settings.each do |position_point|
        new_position_point = {}
        position_name = position_point[:position]
        delete_unwanted_key!(position_point)
        position_point.keys.each do |property|
          new_position_point[point_properties.key(property.to_sym)] =
            position_point[property]
        end
        new_point_settings[position_name.to_sym] = new_position_point
      end
      options['model'].point_scoring_settings = new_point_settings
    end

    def point_scoring_mapper
      point_mapper = SCORING_DEFAULT['point_mapper']
      point_mapper.each_with_object({}) do |(k, v), memo|
        memo[k.to_sym] = v.to_sym
      end
    end
  end
end
