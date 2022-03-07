# frozen_string_literal: true

module Api
  module V1
    module User
      # to create user
      class ForgetPassword < ::User::ForgetPassword
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :fname
          property :lname
          property :reset_password_token
        end
      end
    end
  end
end
