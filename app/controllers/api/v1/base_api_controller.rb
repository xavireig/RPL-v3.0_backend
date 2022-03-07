# frozen_string_literal: true

module Api
  module V1
    class BaseApiController < ApplicationController
      before_action :authenticate_user_from_token!

      private

      def authenticate_user_from_token!
        if params['auth_token'].present?
          @current_user = ::User.where(authentication_token:
                                         params['auth_token']).first
        end

        if @current_user.blank?
          render json: { success: 404, message: 'Invalid Auth Data' }
        else
          @current_user.save
        end
      end
    end
  end
end
