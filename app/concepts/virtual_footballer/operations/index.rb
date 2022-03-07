# frozen_string_literal: true

class VirtualFootballer < ApplicationRecord
  # this operation gets all footballers in current season
  class Index < Trailblazer::Operation
    step :find_league
    failure :league_not_found, fail_fast: true
    # step :draft_now?
    # failure :draft_not_started
    step :virtual_footballers_list_by_season

    private

    def find_league(options, params:, **)
      league =
        # ::League.find(params[:league_id])
        ::League.includes(
          # virtual_footballers: { footballer: %i[current_club running_fixture] }
          virtual_footballers: [
            :virtual_club,
            footballer:
              [:current_club, running_fixture: %i[home_club away_club]]
          ]
        ).find(params[:league_id])
      options['league'] = league
    rescue ActiveRecord::RecordNotFound
      false
    end

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def draft_now?(options)
      options['league'].draft_time > Time.now ? false : true
    end

    def draft_not_started(options)
      options['message'] = 'Draft has not started yet'
    end

    def virtual_footballers_list_by_season(options)
      options['model'] = options['league'].virtual_footballers
    end
  end
end
