# frozen_string_literal: true

# Draft order
class DraftOrder < ApplicationRecord
  # to update draft order
  class Update < Trailblazer::Operation
    extend Contract::DSL

    step Model(::League, :find_by)
    failure :league_not_found
    step :update_draft_order!
    step :broadcast_draft_order

    private

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def update_draft_order!(options, params:, **)
      draft_order = options['model'].draft_order
      draft_order.queue = params[:queue]
      draft_order.save
    end

    def broadcast_draft_order(options)
      ::DraftOrder::Broadcast.call(id: options['model'].id)
    end
  end
end
