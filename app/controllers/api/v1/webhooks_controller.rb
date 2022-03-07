# frozen_string_literal: true

module Api
  module V1
    class WebhooksController < ApplicationController
      skip_before_action :auth_token_from_header!

      def index
        _result =
          ::Subscription::ParseBraintreeWebhook.call(params)

        render json: {
          success: 0
        }
      rescue => e
        Rails.logger.error "+B+ webhook error #{e.backtrace.join('\n')}"
      end
    end
  end
end
