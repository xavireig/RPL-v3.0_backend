# frozen_string_literal: true

class Club < ApplicationRecord
  # real clubs list
  class RealTeamsList < Trailblazer::Operation
    extend Contract::DSL

    step :find_league
    failure :could_not_find_league
    step :real_clubs

    private

    def find_league(options, params:, **)
      league = ::League.includes(:season).find(params[:league_id])
      options['league'] = league
    end

    def could_not_find_league(options)
      options['message'] = 'League not found'
    end

    def real_clubs(options)
      current_season = options['league'].season
      clubs = current_season.clubs
      options['model'] = clubs
    end
  end
end
