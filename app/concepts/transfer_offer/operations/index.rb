# frozen_string_literal: true

class TransferOffer < ApplicationRecord
  # to send a transfer offer to a club
  class Index < Trailblazer::Operation
    step :find_virtual_club
    failure :club_not_found, fail_fast: true

    private

    def find_virtual_club(options, params:, **)
      club =
        ::VirtualClub.includes(
          :offered_transfer_offers,
          :requested_transfer_offers,
          virtual_footballers: { footballer: %i[clubs current_sdp] }
        ).find(params[:club_id])
      options['model'] = club
    rescue ActiveRecord::RecordNotFound
      false
    end

    def club_not_found(options)
      options['message'] = 'Club not found'
    end
  end
end
