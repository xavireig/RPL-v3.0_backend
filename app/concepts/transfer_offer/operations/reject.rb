# frozen_string_literal: true

class TransferOffer < ApplicationRecord
  # to send a transfer offer to a club
  class Reject < Trailblazer::Operation
    extend Contract::DSL

    step Model(::TransferOffer, :find_by)
    failure :transfer_offer_expired, fail_fast: true
    step :update_transfer_offer_status
    step :fetch_sender_virtual_club
    step :fetch_receiver_virtual_club
    step :create_notification
    failure :could_not_create_notification, fail_fast: true

    private

    def transfer_offer_expired(options)
      options['message'] = 'Transfer offer has expired!'
    end

    def update_transfer_offer_status(options)
      options['model'].status = 3
      options['model'].save
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
          recipient_id: options['sender_vc'].user_id,
          sender_id: options['receiver_vc'].user_id,
          activity_type: Notification::ActivityTypes::REJECT,
          object_type: options['model'].class,
          object_id: options['model'].id,
          content: "#{options['receiver_vc'].name} has rejected your transfer bid",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create Transfer Rejected Notification. Please try again!'
    end
  end
end
