# frozen_string_literal: true

module Api
  module V1
    module League
      # to show individual league information
      class PublicLeagues < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::League do
            property :id
            property :title
            property :description
            property :draft_status
            property :draft_time

            property :invite_code
            property :num_teams, exec_context: :decorator
            property :required_teams, as: :req_teams
            property :scoring_type, as: :league_scoring_type
            property :transfer_budget

            def num_teams
              ::VirtualClub.where(league_id: represented.id).count
            end
          end
        end
      end
    end
  end
end
