# frozen_string_literal: true

module Api
  module V1
    module VirtualClub
      # api response using representer for getting list
      # of virtual clubs of user in past season and current season
      class ListOfUserClub < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          nested :current_season_clubs do
            include Representable::JSON::Collection
            items class: ::VirtualClub do
              property :id
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
                property :num_teams, exec_context: :decorator
                property :required_teams, as: :req_teams
                property :user_id

                def num_teams
                  ::VirtualClub.where(league_id: represented.id).count
                end
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
          # TODO: old season clubs
        end
      end
    end
  end
end
