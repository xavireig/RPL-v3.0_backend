# frozen_string_literal: true

class League < ApplicationRecord
  # to get league from league invite code
  class GetLeagueFromInviteCode < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :code
    end

    step :invited_league

    def invited_league(options, params:, **)
      league = League.find_by(invite_code: params[:code])
      if league.blank?
        options['message'] =
          'Whoops-looks like that code isn\'t right. Please try again.'
        false
      else
        options['model'] = league
      end
    end
  end
end
