# frozen_string_literal: true

class User < ApplicationRecord
  # get user details by email
  class ForgetPassword < Trailblazer::Operation
    success :find_user
    step :send_reset_password_instructions!

    private

    def send_reset_password_instructions!(options, params:, **)
      if options['model'].present?
        options['model'].send_reset_password_instructions
      else
        options['model'] = User.new
        options['model'].errors.add(:base, 'Email not found')
        false
      end
    end

    def find_user(options, params:, **)
      options['model'] = ::User.find_by(email: params[:email])
    end
  end
end
