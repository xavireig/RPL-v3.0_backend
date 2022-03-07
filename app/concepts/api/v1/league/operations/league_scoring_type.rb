# frozen_string_literal: true

require 'disposable/twin/property/hash'

module Api
  module V1
    module League
      # to show league point scoring
      class LeagueScoringType < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          category_mapper = SCORING_DEFAULT['category_mapper']
          category_properties =
            category_mapper.each_with_object({}) do |(k, v), memo|
              memo[k.to_sym] = v.to_sym
            end

          nested :league_sco_cat do
            category_properties.each do |key, value|
              property value, exec_context: :decorator

              define_method value do
                represented.category_scoring_settings[key.to_s]
              end
            end
          end

          point_mapper = SCORING_DEFAULT['point_mapper']
          point_properties =
            point_mapper.each_with_object({}) do |(k, v), memo|
              memo[k.to_sym] = v.to_sym
            end

          property :weight_goals_category
          property :fantasy_assist
          nested :league_sco_type do
            property :id, as: :league_id
            property :scoring_type
            property :category_default,
              as: :is_cat_default,
              exec_context: :decorator

            property :point_default,
              as: :is_point_default,
              exec_context: :decorator

            def category_default
              !represented.customized_scoring
            end

            def point_default
              !represented.customized_scoring
            end
          end

          property :point_scoring_settings,
            as: :league_sco_points,
            render_filter: lambda { |input, **|
              input.map do |k, v|
                OpenStruct.new(v.merge(position: k))
              end
            } do
            include Representable::JSON::Collection
            items class: OpenStruct do
              property :position

              point_properties.each do |key, value|
                property value, exec_context: :decorator

                define_method value do
                  represented[key.to_s]
                end
              end
            end
          end
        end
      end
    end
  end
end
