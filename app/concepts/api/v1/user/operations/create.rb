# frozen_string_literal: true

module Api
  module V1
    module User
      # to create user
      class Create < ::User::Create
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :email
          property :fname
          property :lname
          property :full_name
          property :authentication_token, as:
                   :auth_token
          property :check_if_email_confirmed, as:
                   :is_email_true, exec_context: :decorator

          def check_if_email_confirmed
            represented.confirmed_at.nil? ? false : true
          end
        end
      end
    end
  end
end
