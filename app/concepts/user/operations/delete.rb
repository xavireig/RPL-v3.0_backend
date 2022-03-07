# frozen_string_literal: true

class User < ApplicationRecord
  # to create user
  class Delete < Trailblazer::Operation
    extend Contract::DSL

    step :delete!

    private

    def delete!(options, params:, **)
      user = ::User.find_by(email: params[:email])
      if user.present?
        timestamp = Time.now.to_i
        user.email = "#{user.email}_deleted_#{timestamp}"
        user.deleted = true
        user.skip_confirmation!
        user.save!
        options['model'] = user
      end
    end
  end
end
