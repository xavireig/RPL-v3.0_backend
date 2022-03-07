# frozen_string_literal: true

module Api
  module V1
    module Club
      # representer for getting all real teams in current season
      class RealTeamsList < ::Club::RealTeamsList
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::Club do
            property :id
            property :u_id, as: :extid
            property :name
            property :short_club_name
          end
        end
      end
    end
  end
end
