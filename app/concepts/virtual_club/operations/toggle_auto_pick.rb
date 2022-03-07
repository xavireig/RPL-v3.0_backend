# frozen_string_literal: true

# Draft controller
class VirtualClub
  # to toggle auto pick
  class ToggleAutoPick < Trailblazer::Operation
    extend Contract::DSL

    step :find_league
    failure :league_not_found, fail_fast: true
    step :find_club
    failure :club_not_found, fail_fast: true
    step :draft_now?
    failure :draft_not_started, fail_fast: true
    step :toggle_auto_pick!

    def find_league(options, params:, **)
      league = ::League.find(params[:league_id])
      options['league'] = league
    rescue ActiveRecord::RecordNotFound
      false
    end

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def find_club(options, params:, **)
      virtual_club =
        ::VirtualClub.where(
          league_id: params[:league_id],
          user_id: params[:current_user].id
        ).first
      options['virtual_club'] = virtual_club
    rescue ActiveRecord::RecordNotFound
      false
    end

    def club_not_found
      options['message'] = 'Club not found'
    end

    def draft_now?(options)
      options['league'].draft_status == 'running' ? true : false
    end

    def draft_not_started(options)
      options['message'] = 'Draft has not started yet'
    end

    def toggle_auto_pick!(options, params:, **)
      options['virtual_club'].auto_pick = params[:toggle]
      options['virtual_club'].save
      options['model'] = options['virtual_club']
    end
  end
end
