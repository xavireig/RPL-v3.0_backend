# frozen_string_literal: true

# sends mail to user
class UserMailer < ApplicationMailer
  def invite(current_user, user, league)
    @chairman = current_user
    @recipient = user
    @chairman_league = league

    mail(
      to: @recipient,
      subject: 'You\'ve been invited to RotoPremierLeague'
    )
  end
end
