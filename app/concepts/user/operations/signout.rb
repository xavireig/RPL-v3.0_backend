# frozen_string_literal: true

class User < ApplicationRecord
  # for signout user
  class Signout < Trailblazer::Operation
    step :model!
    step :signout!

    def model!(options, params:, **)
      options['model'] =
        User.where(authentication_token: params['auth_token']).first
    end

    def signout!(options, model:, **)
      if options['model'].present?
        model.authentication_token = nil
        model.save!
      end
    end
  end
end
