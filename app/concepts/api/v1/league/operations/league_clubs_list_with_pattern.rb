# frozen_string_literal: true

module Api
  module V1
    module League
      # for league general information
      class LeagueClubsListWithPattern < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON
          collection :virtual_clubs, as: :clubs_list do
            property :id
            property :name
            property :stadium
            property :motto
            property :color1
            property :color2
            property :color3
            property :crest_pattern_id
            property :crest_pattern do
              property :id
              property :svg_url
              property :crest_shape_id
            end
            property :budget
          end
          nested :league do
            property :id
            property :title
            property :draft_time
            property :draft_status
            property :num_teams, exec_context: :decorator
            property :req_teams, exec_context: :decorator
            property :user_id
            property :squad_size, as: :squad_count

            def req_teams
              represented.required_teams
            end

            def num_teams
              ::VirtualClub.where(league_id: represented.id).count
            end
          end
        end
      end
    end
  end
end
