# frozen_string_literal: true

class User < ApplicationRecord
  # get user details by email
  class SaveNewPassword < Trailblazer::Operation
    step :find_user
    step :save_password

    private

    def save_password(options, params:, **)
      if options['model'].present?
        options['model'].password = params['data']['new_password']
        options['model'].save
      else
        options['model'] = User.new
        options['model'].errors.add(
          :base,
          'No user found for given reste token.'
        )
        false
      end
    end

    def find_user(options, params:, **)
      options['model'] = ::User.find_by(
        reset_password_token: params['data']['reset_token']
      )
      true
    end
  end
end
