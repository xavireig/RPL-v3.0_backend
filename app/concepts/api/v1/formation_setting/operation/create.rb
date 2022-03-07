# frozen_string_literal: true

module Api
  module V1
    module Formation
      # to create default formation settings
      class Create < ::Formation::Create
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end
    end
  end
end
