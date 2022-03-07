# frozen_string_literal: true

class Invitation < ApplicationRecord
  # get user's all league invites
  class Index < Trailblazer::Operation
    extend Contract::DSL

    step :get_invitations_if_league_exists

    private

    def get_invitations_if_league_exists(options, params:, **)
      league = League.find(params[:league_id])
      if league.blank?
        options['message'] = 'League not found'
        false
      else
        league_invite = Invitation.where(league: league)
        options['model'] = league_invite
      end
    end
  end
end
