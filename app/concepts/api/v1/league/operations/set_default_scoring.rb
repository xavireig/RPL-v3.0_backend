# frozen_string_literal: true

module Api
  module V1
    module League
      # to update league
      class DefaultScoring < ::League::DefaultScoring
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end
    end
  end
end
