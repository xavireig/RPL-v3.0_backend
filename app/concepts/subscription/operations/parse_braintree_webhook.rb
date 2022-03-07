# frozen_string_literal: true

class Subscription < ApplicationRecord
  # get user's all league invites
  class ParseBraintreeWebhook < Trailblazer::Operation
    extend Contract::DSL

    step :parse
    step :update_user_subscription

    private

    def parse(options, params:, **)
      webhook_notification = Braintree::WebhookNotification.parse(
        params['bt_signature'],
        params['bt_payload']
      )

      Rails.logger.subscription.error "-----webhook with data #{webhook_notification.inspect}"
      Rails.logger.subscription.error "-----webhook_notification.subscription #{webhook_notification.subscription.inspect}"
      Rails.logger.subscription.error "-----webhook kind #{webhook_notification.kind}"

      options['subscription'] = webhook_notification.subscription
      options['kind'] = webhook_notification.kind
    end

    def update_user_subscription(options)
      Rails.logger.subscription.error "-----update_user_subscription  #{options.inspect}"

      return true unless
        options['kind'] == 'subscription_charged_successfully'

      user =
        ::User.find_by(braintree_subscription_id: options['subscription'].id)
      Rails.logger.subscription.error "-----user subscription charged successfully  #{user.inspect}"
      Rails.logger.subscription.error "-----new subscription end date #{options['subscription'].next_billing_date}"
      # 24 hours buffer time
      user.subscription.update_attributes(
        end_date: options['subscription'].next_billing_date + 24.hours
      )
    end
  end
end
