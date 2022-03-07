# frozen_string_literal: true

module Api
  module V1
    class EplFixturesController < ApplicationController
      def index
        league = ::League.
          includes(season: [fixtures: %i[round home_club away_club]]).
          find(params[:league_id])
        fixtures = league.season.fixtures
        result = Fixture::Index.call['representer.render.class'].new(fixtures)
        render json: { success: 0, result: result }

      end
    end
  end
end
