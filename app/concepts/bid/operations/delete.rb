# frozen_string_literal: true

# Bid
class Bid < ApplicationRecord
  # to delete a waiver bid
  class Delete < Trailblazer::Operation
    extend Contract::DSL

    step Model(::Bid, :find_by)
    failure :bid_not_found, fail_fast: true
    step :delete_bid
    step :fetch_vf
    failure :vf_not_found, fail_fast: true
    step :create_notification
    failure :could_not_create_notification, fail_fast: true

    private

    def bid_not_found(options)
      options['message'] = 'Bid does not exist!'
    end

    def delete_bid(options)
      options['model'].destroy
    end

    def fetch_vf(options, params:, **)
      options['vf'] = VirtualFootballer.find(options['model'].auction.virtual_footballer_id)
    rescue ActiveRecord::RecordNotFound
      false
    end

    def vf_not_found(options)
      options['message'] = 'Bid footballer not found!'
    end

    def create_notification(options, params:, **)
      options['notification'] =
        Notification.create(
          league_id: options['model'].bidder_virtual_club.league.id,
          recipient_id: options['model'].bidder_virtual_club.user_id,
          sender_id: options['model'].bidder_virtual_club.league.user_id,
          activity_type: Notification::ActivityTypes::WAVER_DELETE,
          object_type: options['model'].class,
          object_id: options['model'].id,
          content: "Your bid on #{options['vf'].footballer.name} (£#{options['model'].amount}M) was deleted",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create Bid Deleted Notification. Please try again!'
    end
  end
end
