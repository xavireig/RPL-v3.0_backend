# frozen_string_literal: true

module Api
  module V1
    module User
      # to create user
      class Signin < ::User::Signin
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :fname
          property :lname
          property :email
          property :authentication_token, as:
                   :auth_token
          property :check_if_email_confirmed, as:
                   :is_email_true, exec_context: :decorator
          property :subscription, render_nil: true do
            property :trial?, as: :isTrial
            property :end_date
          end

          def check_if_email_confirmed
            represented.confirmed_at.nil? ? false : true
          end
        end
      end
    end
  end
end
