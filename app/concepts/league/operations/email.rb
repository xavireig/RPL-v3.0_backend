# frozen_string_literal: true

class League < ApplicationRecord
  # to email all members of league
  class Email < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :subject
      property :body
      validates :id, presence: true
      validates :subject, presence: true
      validates :body, presence: true
    end

    step Model(::League, :find_by)
    failure :league_not_found
    step :send_email_to_all_members

    private

    def league_not_found(options)
      options['message'] = 'League not found!'
    end

    def send_email_to_all_members(options, params:, **)
      LeagueMailer.send_all(
        params[:current_user].id,
        options['model'].id,
        params[:subject],
        params[:body]
      ).deliver_later
    end
  end
end
