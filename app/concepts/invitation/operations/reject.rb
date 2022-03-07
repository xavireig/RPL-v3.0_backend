# frozen_string_literal: true

class Invitation < ApplicationRecord
  # reject existing invitation to join league
  class Reject < Trailblazer::Operation
    extend Contract::DSL

    step :find_league
    failure :league_not_found
    step :find_invite
    failure :invite_not_found
    step :reject_invite!
    failure :could_not_reject_invite

    private

    def find_league(options, params:, **)
      league = League.find(params[:id])
      options['model'] = league
    end

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def find_invite(options, params:, **)
      invite =
        Invitation.where(
          league: params[:id],
          email: params[:current_user].email
        ).first
      options['invite'] = invite
    end

    def invite_not_found(options)
      options['message'] = 'You do not have an invitation to join this league'
    end

    def reject_invite!(options)
      options['invite'].status = 'rejected'
      options['invite'].save
    end

    def could_not_reject_invite(options)
      options['message'] = 'Could not reject invite. Please try again'
    end
  end
end
