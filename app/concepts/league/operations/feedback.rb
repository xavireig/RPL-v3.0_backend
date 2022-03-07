# frozen_string_literal: true

class League < ApplicationRecord
  # to email all members of league
  class Feedback < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :subject
      property :message
      property :favourite_goal
      validates :favourite_goal, presence: true
      validates :subject, presence: true
      validates :message, presence: true
    end

    step :send_feedback

    def send_feedback(options, params:, **)
      FeedbackMailer.send_feedback(
        params[:current_user_id],
        params[:subject],
        params[:message],
        params[:favourite_goal]
      ).deliver_later
    end
  end
end
