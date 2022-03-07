# frozen_string_literal: true

module Api
  module V1
    module League
      # invite users to join league
      class TransferAdditionalSettings < ::League::TransferAdditionalSettings
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          nested :trans_addit_set do
            property :transfer_budget, as: :annual_transfer_budget
            property :chairman_veto, as: :chairman_vetto
          end
        end
      end
    end
  end
end
