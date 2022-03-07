# frozen_string_literal: true

class Subscription < ApplicationRecord
  # to create user
  class StartTrialSubscription < Trailblazer::Operation
    extend Contract::DSL

    step :subscription

    private

    def subscription(options, params:, **)
      user = ::User.find_by(id: params[:user_id])

      if user.subscription
        options['error_msg'] =
          'You are not eligible for trial subscription'

        return false
      end

      options['subscription'] = create_trial_sub(user)

      if options['subscription']
        true
      else
        options['error_msg'] = 'Trial subscription create fail'
        false
      end
    end

    def create_trial_sub(user)
      user.create_subscription(
        start_date: Time.now,
        end_date: Time.now + Subscription::TRIAL_DAYS.days,
        sub_type: Subscription.sub_types[:trial]
      )
    end
  end
end
