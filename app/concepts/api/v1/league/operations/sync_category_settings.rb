# frozen_string_literal: true

module Api
  module V1
    # league module
    module League
      # represent synchronized category data
      class SyncCategorySettings < ::League::SyncCategorySettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          category_mapper = SCORING_DEFAULT['category_mapper']
          category_properties =
            category_mapper.each_with_object({}) do |(k, v), memo|
              memo[k.to_sym] = v.to_sym
            end
          property :weight_goals_category
          property :fantasy_assist
          nested :league_sco_type do
            category_properties.each do |key, value|
              property value, exec_context: :decorator

              define_method value do
                represented.category_scoring_settings[key.to_s]
              end
            end
          end
        end
      end
    end
  end
end
