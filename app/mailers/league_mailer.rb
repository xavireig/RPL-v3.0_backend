# frozen_string_literal: true

class LeagueMailer < ApplicationMailer
  def send_all(current_user_id, league_id, subject, body)
    @current_user = User.find(current_user_id)
    @league = League.find(league_id)
    @body = body

    mail(
      to: @league.members.pluck(:email).join(','),
      reply_to: @current_user.email,
      subject: subject
    )
  end
end
