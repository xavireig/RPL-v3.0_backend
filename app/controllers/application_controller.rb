# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Helpers
  # before_action :authenticate_user!
  before_action :auth_token_from_header!
  before_action :prepare_exception_notifier

  private

  def auth_token_from_header!
    params['auth_token'] = request.headers['HTTP_X_AUTH_TOKEN'] unless
      request.headers['HTTP_X_AUTH_TOKEN'].blank?
  end

  # https://github.com/smartinez87/exception_notification#actionmailer-configuration
  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: @current_user
    }
  end

  def current_season
    @_current_season ||= Season.current_season
  end

  helper_method :current_season
end
