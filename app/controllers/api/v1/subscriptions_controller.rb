# frozen_string_literal: true

# module comment
module Api
  # comment
  module V1
    class SubscriptionsController < BaseApiController
      before_action :authenticate_user_from_token!

      def index
        result =
          Subscription::Index.call

        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: 'Something wrong with braintree plans'
          }
        end
      end

      def create
        result =
          Subscription::Create.call(
            params.merge!(user: @current_user)
          )

        if result.success?
          render json: {
            success: 0,
            end_date: result['model'].end_date,
            isTrial: result['model'].trial?,
            message: 'payment successful'
          }
        else
          render json: {
            success: 500,
            message: result['error_msg']
          }
        end
      end

      def destroy
        result =
          ::Subscription::Cancel.call(
            params.merge!(user: @current_user)
          )

        if result.success?
          render json: {
            success: 0
          }
        else
          render json: { success: 500,
                         message: result['error_msg'] }
        end
      end

      def user_status
        render json: {
          success: 0,
          result: @current_user.subscription || {}
        }
      end

      def subscription_token
        token = Braintree::ClientToken.generate
        render json: { success: 0, result: token }
      rescue => e
        render json: { success: 500, message: e.message }
      end

      def start_trial_subscription
        result =
          ::Subscription::StartTrialSubscription.call(
            params.merge!(user: @current_user)
          )

        if result.success?
          render json: {
            success: 0,
            end_date: result['subscription'].end_date,
            isTrial: result['subscription'].trial?,
            message: 'successfully trial started'
          }
        else
          render json: { success: 500,
                         message: result['error_msg'] }
        end
      end
    end
  end
end
