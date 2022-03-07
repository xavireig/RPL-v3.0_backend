# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

ENV['RAILS_ADMIN_THEME'] = 'rollincode'
module RotoPremierLeague
  # RPL specific configurations will stay here.
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
    config.active_record.schema_format = :sql
    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.middleware.use Rack::MethodOverride
    config.eager_load = true
    config.to_prepare do
      Devise::Mailer.layout 'mailer'
    end
  end
end

CONFIG =
  YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env]
