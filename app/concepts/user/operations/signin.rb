# frozen_string_literal: true

class User < ApplicationRecord
  # for signin user
  class Signin < Trailblazer::Operation
    step :model!
    step :authorize!

    private

    def model!(options, params:, **)
      user = ::User.find_for_authentication(email: params[:email])
      if user.blank?
        options['message'] = 'Email address or password is incorrect'
        false
      elsif user.confirmed_at.blank?
        options['message'] = 'You have not confirmed you account yet!'
        false
      else
        options['model'] = user
      end
    end

    def authorize!(options, params:, model:, **)
      if !model.nil? && model.valid_password?(params[:password])
        model.update_attributes(
          authentication_token: generate_authentication_token
        )
        model.save!
      else
        options['message'] = 'Email address or password is incorrect'
        false
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
