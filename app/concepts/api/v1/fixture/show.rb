# frozen_string_literal: true

module Api
  module V1
    module Fixture
      # to show individual draft order of a league
      class Show < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          property :id
          property :u_id, as: :fixture_id
          property :date, as: :scheduled
          property :home_score
          property :away_score
          property :period, as: :ext_match_status
          property :now_play
          property :done?, as: :is_done
          property :virt_round, exec_context: :decorator

          def virt_round
            represented.round.number
          end

          property :away_club, as: :away_real_team do
            property :id
            property :u_id, as: :extid
            property :short_club_name
          end

          property :home_club, as: :home_real_team do
            property :id
            property :u_id, as: :extid
            property :short_club_name
          end
        end
      end
    end
  end
end
