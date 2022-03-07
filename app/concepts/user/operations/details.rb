# frozen_string_literal: true

class User < ApplicationRecord
  # get user details by email
  class Details < Trailblazer::Operation
    step :find_user

    def find_user(options, params:, **)
      options['model'] = ::User.find_by(email: params[:email])
    rescue ActiveRecord::RecordNotFound
      true
    end
  end
end
