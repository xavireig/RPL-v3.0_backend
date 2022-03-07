# frozen_string_literal: true

class TransferOffer < ApplicationRecord
  # to revoke a transfer offer
  class Delete < Trailblazer::Operation

    step Model(::TransferOffer, :find_by)
    failure :transfer_offer_not_found, fail_fast: true
    step :fetch_sender_virtual_club
    step :fetch_receiver_virtual_club
    step :revoke_transfer_offer
    step :create_notification
    failure :could_not_create_notification, fail_fast: true

    private

    def transfer_offer_not_found(options)
      options['message'] = 'Transfer offer does not exist!'
    end

    def revoke_transfer_offer(options)
      options['model'].destroy
    end

    def fetch_sender_virtual_club(options)
      options['sender_vc'] = options['model'].sender_virtual_club
    end

    def fetch_receiver_virtual_club(options)
      options['receiver_vc'] = options['model'].receiver_virtual_club
    end

    def create_notification(options, params:, **)
      options['notification'] =
        Notification.create(
          league_id: options['receiver_vc'].league_id,
          recipient_id: options['receiver_vc'].user_id,
          sender_id: options['sender_vc'].user_id,
          activity_type: Notification::ActivityTypes::REVOKE,
          object_type: options['model'].class,
          object_id: options['model'].id,
          content: "#{options['receiver_vc'].name} has revoked the transfer bid",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create Transfer Revoked Notification. Please try again!'
    end
  end
end
