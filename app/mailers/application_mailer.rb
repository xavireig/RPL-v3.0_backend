# frozen_string_literal: true

# All default config for mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'ROTO PREMIER LEAGUE <support@rotopremierleague.com>'
  layout 'mailer'
end
