# frozen_string_literal: true

class User < ApplicationRecord
  # to check user confirmation token
  class Confirm < Trailblazer::Operation
    extend Contract::DSL

    step :check_confirm_token

    private

    def check_confirm_token(options, params:, **)
      unless params['confirm_code'].blank?
        user =
          User.where(
            confirmation_token: params['confirm_code']
          ).first
        if user.present?
          user.confirmed_at = Time.now
          user.authentication_token = generate_authentication_token
          user.save!
        end
        options['model'] = user
      end
    end

    def generate_authentication_token
      loop do
        token = SecureRandom.uuid.delete('')
        break token unless
            ::User.where(authentication_token: token).first
      end
    end
  end
end
