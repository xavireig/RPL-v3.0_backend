# frozen_string_literal: true

module Api
  module V1
    # league module
    module League
      # represent synchronized category data
      class SyncPointSettings < ::League::SyncPointSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON
        end
      end
    end
  end
end
