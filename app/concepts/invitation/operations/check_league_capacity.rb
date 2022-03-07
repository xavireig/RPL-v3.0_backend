# frozen_string_literal: true

class Invitation < ApplicationRecord
  # invite member to join league
  class CheckLeagueCapacity < Trailblazer::Operation
    extend Contract::DSL

    step :find_invite
    step :find_league
    step :check_league_capacity

    private

    def find_invite(options, params:, **)
      invite = Invitation.find(params[:invite_id])
      if invite.blank?
        options['message'] = 'Invite not found'
        false
      else
        options['invite'] = invite
      end
    end

    def find_league(options)
      league = League.find(options['invite'].league_id)
      if league.present?
        options['league'] = league
      else
        options['message'] = 'League not found'
        false
      end
    end

    def check_league_capacity(options)
      league_clubs =
        VirtualClub.where(league_id: options['league'].id).count
      if league_clubs >= options['league'].required_teams
        options['message'] =
          'Sorry, this league is now full.
          Please create a new league or find another to join.'
        false
      else
        true
      end
    end
  end
end
