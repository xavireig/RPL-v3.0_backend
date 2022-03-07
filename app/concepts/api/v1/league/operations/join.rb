# frozen_string_literal: true

module Api
  module V1
    module League
      # api response using representer for league join
      class Join < ::League::Join
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :name
          property :stadium, render_nil: true
          property :motto, render_nil: true
          property :abbr, render_nil: true
          property :color1
          property :color2
          property :color3
          property :league_id, render_nil: true
          property :league, render_nil: true do
            property :id
            property :title
            property :draft_time
            property :draft_status
            # property :num_teams
            property :required_teams, as: :req_teams
            property :user_id
          end
          property :user_id
          property :crest_pattern_id
          property :crest_pattern do
            property :id
            property :svg_url
            property :crest_shape_id
          end
          property :budget
        end
      end
    end
  end
end
