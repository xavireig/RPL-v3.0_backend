# frozen_string_literal: true

module Api
  module V1
    # league module
    module League
      # invite users to join league
      class PublicListing < ::League::PublicListing
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end
    end
  end
end
