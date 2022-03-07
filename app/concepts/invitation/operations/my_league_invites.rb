# frozen_string_literal: true

class Invitation < ApplicationRecord
  # gets user's all league invites based on filter
  class MyLeagueInvites < Trailblazer::Operation
    extend Contract::DSL

    step :my_invitations

    private

    def my_invitations(options, params:, **)
      filter = params['filter'] || ''
      league_invite = Invitation.where(email: params[:current_user].email)
      if filter.blank?
        options['model'] = league_invite
      else
        options['model'] = league_invite.where(status: filter)
      end
    end
  end
end
