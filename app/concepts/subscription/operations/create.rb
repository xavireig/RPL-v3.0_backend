# frozen_string_literal: true

class Subscription < ApplicationRecord
  # to create user
  class Create < Trailblazer::Operation
    extend Contract::DSL

    step :create_braintree_sub

    private

    def create_braintree_sub(options, params:, **)
      user = params[:user]

      if user.braintree_subscription_id.present? && active_subscription?(user.braintree_subscription_id)
        options['error_msg'] = 'Subscription exist for this user'
        return
      end

      customer =
        find_or_create_customer_by_user(user)
      payment_method =
        create_payment_method_for_customer(customer, params[:nonce])

      create_subscription(user, payment_method, params[:plan])
      options['model'] = user.reload.subscription
    end

    def find_or_create_customer_by_user(user)
      if user.braintree_customer_id.blank?
        create_customer(user)
      else
        Braintree::Customer.find(user.braintree_customer_id)
      end
    rescue Braintree::NotFoundError => _e
      create_customer(user)
    end

    def create_customer(user)
      result = Braintree::Customer.create(
        first_name: user.fname,
        last_name: user.lname,
        email: user.email
      )
      raise OurException.new(501, result.errors.first.message) unless
        result.success?
      user.update(braintree_customer_id: result.customer.id)
      result.customer
    end

    def create_payment_method_for_customer(customer, nonce)
      result = Braintree::PaymentMethod.create(
        customer_id: customer.id,
        payment_method_nonce: nonce
      )
      raise OurException.new(502, result.errors.first.message) unless
        result.success?
      result.payment_method
    end

    def create_subscription(
      user, payment_method, plan_id, merchant_account_id = nil
    )
      sub_attrs = {
        payment_method_token: payment_method.token,
        plan_id: plan_id
      }

      sub_attrs[:merchant_account_id] = merchant_account_id if
        merchant_account_id

      ::User.transaction do
        result = Braintree::Subscription.create sub_attrs
        raise OurException.new(503, result.errors.first.message) unless
          result.success?

        update_user_subscription(user, result)
      end
    end

    def update_user_subscription(user, result)
      if user.subscription
        update_subscription(user, result)
      else
        create_sub(user, result)
      end

      user.update(braintree_subscription_id: result.subscription.id)
    end

    def create_sub(user, result)
      user.create_subscription(
        start_date: Time.now,
        end_date: result.subscription.next_billing_date,
        sub_type: Subscription.sub_types[:premium]
      )
    end

    def update_subscription(user, result)
      user.subscription.update_attributes(
        start_date: Time.now,
        end_date: result.subscription.next_billing_date,
        sub_type: Subscription.sub_types[:premium]
      )
    end

    def active_subscription?(subscription_id)
      bs = Braintree::Subscription.find(subscription_id)
      bs.status == 'Active'
    rescue => e
      Rails.logger.subscription.error ">>>>>>> error finding subscription user #{subscription_id}"
      Rails.logger.subscription.error e
    end
  end
end
