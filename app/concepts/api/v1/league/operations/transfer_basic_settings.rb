# frozen_string_literal: true

module Api
  module V1
    module League
      # invite users to join league
      class TransferBasicSettings < ::League::TransferBasicSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          nested :tran_basic_settings do
            property :bonus_per_win
            property :bonus_per_draw
            property :min_fee_per_addition, as: :min_fee_per_add
          end
        end
      end
    end
  end
end
