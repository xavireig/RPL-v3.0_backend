# frozen_string_literal: true

module Api
  module V1
    module User
      # to create user
      class Delete < ::User::Delete
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :email
        end
      end
    end
  end
end
