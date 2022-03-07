# frozen_string_literal: true

module Api
  module V1
    class FeedbackController < AuthController
      before_action :authenticate_user_from_token!

      def create
        result = ::League::Feedback.call(
          message: params[:message],
          subject: params[:subject],
          favourite_goal: params[:favourite_goal],
          current_user_id: current_user.id
        )
        if result.success?
          render json: {
            success: 0,
            message: 'Your feedback has been sent successfully.'
          }
        else
          render json: {
            success: 400,
            message: 'Feedback has not been sent. Please try again!'
          }
        end
      end
    end
  end
end
