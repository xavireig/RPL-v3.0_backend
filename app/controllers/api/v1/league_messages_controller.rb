# frozen_string_literal: true

module Api
  module V1
    class LeagueMessagesController < BaseApiController
      def create
        result = ::League::Email.call(
          id: params[:league_id],
          subject: params[:subject],
          body: params[:body],
          current_user: @current_user
        )
        if result.success?
          render json: {
            success: 0,
            message: 'Email successfully sent'
          }
        else
          render json: {
            success: 400,
            message: 'Some of the emails could not be sent'
          }
        end
      end
    end
  end
end
