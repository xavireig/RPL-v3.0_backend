# frozen_string_literal: true

module Api
  module V1
    # league module
    module League
      # invite users to join league
      class ShowDraftSettings < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :title
          property :time_per_pick
          property :time_per_pick_unit
          property :draft_time
          property :draft_status
          property :custom_draft_order
        end
      end
    end
  end
end
