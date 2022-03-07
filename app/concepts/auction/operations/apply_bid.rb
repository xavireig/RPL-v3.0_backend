# frozen_string_literal: true

# Auction
class Auction < ApplicationRecord
  # to make won bid effective in next game week's line up of the winner club
  class ApplyBid < Trailblazer::Operation

    step :fetch_winning_bid
    step :fetch_next_game_week
    step :fetch_league_squad_size
    step :check_winning_club_budget
    failure :not_enough_budget, fail_fast: true
    step :check_winning_bid_club_capacity
    failure :virtual_club_capacity_full, fail_fast: true
    step :check_auctioned_footballer
    failure :auctioned_footballer_left, fail_fast: true
    step :check_dropped_vf
    failure :dropped_vf_club_has_changed, fail_fast: true
    step :drop_virtual_footballer!
    step :create_dropped_transfer_activity!
    step :assign_virtual_club_to_vf!
    step :deduct_club_transfer_budget!
    step :create_virtual_engagements!
    step :create_added_transfer_activity!
    step :update_bids_status!
    step :update_auction_status!
    step :create_notification
    failure :could_not_create_notification

    private

    def fetch_winning_bid(options, params:, **)
      options['winning_bid'] = params[:winning_bid]
    end

    def fetch_next_game_week(options)
      options['next_gw'] = options['winning_bid'].bidder_virtual_club.current_game_week.next_game_week
    end

    def fetch_league_squad_size(options)
      options['league_squad_size'] = options['winning_bid'].bidder_virtual_club.league.squad_size
    end

    def check_winning_club_budget(options)
      if options['winning_bid'].bidder_virtual_club.budget < options['winning_bid'].amount
        false
      else
        true
      end
    end

    def not_enough_budget(options)
      options['winning_bid'].auction.bids.each do |bid|
        bid.status = 1
        bid.save
      end
      options['winning_bid'].auction.processed = true
      options['winning_bid'].auction.save
      options['message'] = 'Not enough budget'
      create_failure_notification(options)
    end

    def check_winning_bid_club_capacity(options)
      if options['winning_bid'].dropped_virtual_footballer.present?
        if options['next_gw'].virtual_engagements.count - 1 <
            options['league_squad_size']
          true
        else
          false
        end
      elsif options['next_gw'].virtual_engagements.count <
          options['league_squad_size']
        true
      else
        false
      end
    end

    def virtual_club_capacity_full(options)
      options['winning_bid'].auction.bids.each do |bid|
        bid.status = 1
        bid.save
      end
      options['winning_bid'].auction.processed = true
      options['winning_bid'].auction.save
      options['message'] = 'Virtual Club capacity is full. Waiver Bid cancelled!'
    end

    def check_auctioned_footballer(options)
      if options['winning_bid'].auction.virtual_footballer.footballer.left?
        false
      else
        true
      end
    end

    def auctioned_footballer_left(options)
      options['winning_bid'].auction.bids.each do |bid|
        bid.status = 1
        bid.save
      end
      options['winning_bid'].auction.processed = true
      options['winning_bid'].auction.save
      options['message'] = 'Auctioned footballer has left!'
    end

    def check_dropped_vf(options)
      return true if options['winning_bid'].dropped_virtual_footballer.nil?
      return false if options['winning_bid'].dropped_virtual_footballer.virtual_club.nil?
      return false if options['winning_bid'].dropped_virtual_footballer.footballer.left?
      options['dropped_vf'] = options['winning_bid'].dropped_virtual_footballer
      if options['dropped_vf'].virtual_club.id ==
          options['winning_bid'].bidder_virtual_club.id &&
          !options['dropped_vf'].transferred
        true
      else
        return false
      end
    end

    def dropped_vf_club_has_changed(options)
      options['winning_bid'].auction.bids.each do |bid|
        bid.status = 1
        bid.save
      end
      options['winning_bid'].auction.processed = true
      options['winning_bid'].auction.save
      options['message'] = 'Dropped footballer does not belong to
        the bidder club anymore!'
    end

    def drop_virtual_footballer!(options)
      return true if options['winning_bid'].dropped_virtual_footballer.nil?
      return false if options['winning_bid'].dropped_virtual_footballer.virtual_club.nil?
      game_week_ids = GameWeek.tree_for(options['next_gw'].previous_game_week).pluck(:id)
      VirtualEngagement.where(
        game_week_id: game_week_ids,
        virtual_footballer_id: options['winning_bid'].dropped_virtual_footballer.id
      ).destroy_all

      ::GameWeek::ChangeFormation.call(
        id: options['next_gw'].id,
        new_formation: options['next_gw'].formation.name
      )

      options['winning_bid'].dropped_virtual_footballer.waiver = true
      options['winning_bid'].dropped_virtual_footballer.virtual_club_id = nil
      options['winning_bid'].dropped_virtual_footballer.save

      options['winning_bid'].dropped_virtual_footballer.auctions.create(
        virtual_round: options['next_gw'].virtual_round
      )
    end

    def create_dropped_transfer_activity!(options)
      return true if options['winning_bid'].dropped_virtual_footballer.nil?
      ::TransferActivity::Create.call(
        league_id: options['winning_bid'].bidder_virtual_club.league.id,
        from_virtual_club_id: options['winning_bid'].bidder_virtual_club.id,
        to_virtual_club_id: nil,
        virtual_footballer_id: options['winning_bid'].dropped_virtual_footballer.id,
        amount: 0,
        auction: true,
        virtual_round_id: options['next_gw'].virtual_round.id
      )
    end

    def assign_virtual_club_to_vf!(options, params:, **)
      options['won_vf'] = options['winning_bid'].auction.virtual_footballer
      options['won_vf'].virtual_club_id = options['winning_bid'].bidder_virtual_club.id
      options['won_vf'].save
    end

    def deduct_club_transfer_budget!(options)
      options['winning_bid'].bidder_virtual_club.budget -= options['winning_bid'].amount
      options['winning_bid'].bidder_virtual_club.save
    end

    def create_virtual_engagements!(options)
      game_week_ids = GameWeek.tree_for(options['next_gw'].previous_game_week).pluck(:id)
      game_week_ids.each do |gw|
        VirtualEngagement.create(
          game_week_id: gw,
          virtual_footballer_id: options['won_vf'].id,
          status: 0
        )
      end
    end

    def create_added_transfer_activity!(options)
      ::TransferActivity::Create.call(
        league_id: options['winning_bid'].bidder_virtual_club.league.id,
        from_virtual_club_id: nil,
        to_virtual_club_id: options['winning_bid'].bidder_virtual_club.id,
        virtual_footballer_id: options['won_vf'].id,
        amount: options['winning_bid'].amount,
        auction: true,
        virtual_round_id: options['next_gw'].virtual_round.id
      )
    end

    def update_bids_status!(options)
      options['winning_bid'].auction.bids.each do |bid|
        bid.update_attribute(:status, 1)
      end
      options['winning_bid'].status = 2
      options['winning_bid'].save
    end

    def update_auction_status!(options)
      options['winning_bid'].auction.processed = true
      options['winning_bid'].auction.save
    end

    def create_notification(options, params:, **)
      options['notification'] =
        Notification.create(
          league_id: options['winning_bid'].bidder_virtual_club.league.id,
          recipient_id: options['winning_bid'].bidder_virtual_club.user_id,
          sender_id: options['winning_bid'].bidder_virtual_club.league.user_id,
          activity_type: Notification::ActivityTypes::WAVER_SUCCESS,
          object_type: options['winning_bid'].class,
          object_id: options['winning_bid'].id,
          content: "Your bid on #{options['won_vf'].footballer.name} (£#{options['winning_bid'].amount}M) was successful",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create Transfer Rejected Notification. Please try again!'
      true
    end

    def create_failure_notification(options)
      options['notification'] =
        Notification.create(
          league_id: options['winning_bid'].bidder_virtual_club.league.id,
          recipient_id: options['winning_bid'].bidder_virtual_club.user_id,
          sender_id: options['winning_bid'].bidder_virtual_club.user_id,
          activity_type: Notification::ActivityTypes::WAVER_FAIL,
          object_type: options['winning_bid'].class,
          object_id: options['winning_bid'].id,
          content: "Your bid on #{options['winning_bid'].auction.virtual_footballer.footballer.name} (£#{options['winning_bid'].amount}M) was unsuccessful",
          time_sent: Time.now
        )
    end
  end
end
