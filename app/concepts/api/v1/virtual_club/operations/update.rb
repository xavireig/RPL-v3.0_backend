# frozen_string_literal: true

module Api
  module V1
    module VirtualClub
      # api response using representer for updating virtual club
      class Update < ::VirtualClub::Update
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :name
          property :stadium, render_nil: true
          property :motto, render_nil: true
          property :abbr, render_nil: true
          property :color1
          property :color2
          property :color3
          property :league_id, render_nil: true
          # property :league
          property :user_id
          property :crest_pattern_id
          # property :crest_pattern
          # property :budget
          # property :season_id
          # property :pts
          # property :place
          # property :user
        end
      end
    end
  end
end
