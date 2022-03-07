# frozen_string_literal: true

module ApplicationCable
  # to establish connection
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      current_user =
        User.find_by(authentication_token: request.params[:token])
      if current_user
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
