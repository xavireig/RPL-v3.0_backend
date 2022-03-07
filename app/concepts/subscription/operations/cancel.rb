# frozen_string_literal: true

class Subscription < ApplicationRecord
  # to create user
  class Cancel < Trailblazer::Operation
    extend Contract::DSL

    step :cancel_braintree_subscription
    step :update_user_subscription

    private

    def cancel_braintree_subscription(options, params:, **)
      user = params[:user]

      subscription_id =
        user.braintree_subscription_id
      result =
        Braintree::Subscription.cancel(subscription_id)

      unless result.success?
        options['error_msg'] =
          result.errors.map(&:message).join('/n')
        return false
      end

      true
    end

    def update_user_subscription(_options, params:, **)
      user = params[:user]

      user.update(
        braintree_subscription_id: nil
      )
    end
  end
end
