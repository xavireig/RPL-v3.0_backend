# frozen_string_literal: true

module Api
  module V1
    module League
      # for league general information
      class LeagueClubs < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          nested :league do
            property :id
            property :title
            property :draft_time
            property :draft_status
            property :user_id
            property :num_teams, exec_context: :decorator
            property :req_teams, exec_context: :decorator
            property :squad_size, as: :squad_count

            def req_teams
              represented.required_teams
            end

            def num_teams
              ::VirtualClub.where(league_id: represented.id).count
            end
          end

          collection :virtual_clubs, as: :clubs_list do
            property :id
            property :name
            property :budget
          end
        end
      end
    end
  end
end
