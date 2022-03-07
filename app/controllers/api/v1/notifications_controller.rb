# frozen_string_literal: true

module Api
  module V1
    class NotificationsController < AuthController
      before_action :authenticate_user_from_token!

      def index
        notifications = ::Notification.unread.
          where(recipient_id: @current_user.id).
          order('created_at DESC')
        response = ::Api::V1::Notification::Index.call['representer.render.class'].new(notifications)
        render json: { success: 0, result: response }
      end

      def league_notifications; end

      def mark_notification_as_viewed
        result = ::Notification::MarkNotificationAsViewed.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message'] }
        end
      end
    end
  end
end
