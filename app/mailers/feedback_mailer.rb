# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def send_feedback(current_user_id, subject, message, favourite_goal)
    @current_user = User.find_by(id: current_user_id)
    @favourite_goal = favourite_goal
    @message = message

    mail(
      to: 'support@rotopremierleague.com',
      reply_to: @current_user.email,
      subject: subject
    )
  end
end
