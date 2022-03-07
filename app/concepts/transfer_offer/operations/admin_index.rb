# frozen_string_literal: true

class TransferOffer < ApplicationRecord
  # to send a transfer offer to a club
  class AdminIndex < Trailblazer::Operation
    step :find_pending_transfer_offers
    failure :error_fetching_pending_transfer_offers, fail_fast: true

    private

    def find_pending_transfer_offers(options, params:, **)
      transfer_offers =
        ::TransferOffer.includes(
          :sender_virtual_club,
          :receiver_virtual_club,
          :offered_virtual_footballers,
          :requested_virtual_footballers
        ).where(status: TransferOffer.statuses[:pending]).
          where(virtual_clubs: {league_id: params[:league_id]})
      options['model'] = transfer_offers
    rescue
      false
    end

    def error_fetching_pending_transfer_offers(options)
      options['message'] = 'Error Fetching Transfer Offers'
    end
  end
end
