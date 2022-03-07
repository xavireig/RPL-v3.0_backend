# frozen_string_literal: true

module Api
  module V1
    module User
      # to create user
      class SaveNewPassword < ::User::SaveNewPassword
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end
    end
  end
end
