# frozen_string_literal: true

module Api
  module V1
    module User
      # signout user
      class Signout < ::User::Signout
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :email
          property :fname
        end
      end
    end
  end
end
