# frozen_string_literal: true

# bid
class Bid < ApplicationRecord
  # to create a bid
  class Create < Trailblazer::Operation
    extend Contract::DSL

    step :fetch_vf
    failure :vf_not_found, fail_fast: true
    step :fetch_vc
    failure :vc_not_found, fail_fast: true
    step :check_budget
    failure :budget_not_enough, fail_fast: true
    step :check_club_capacity_next_gw
    failure :club_capacity_full, fail_fast: true
    step :fetch_dropped_ve
    failure :dropped_ve_not_found, fail_fast: true
    step :check_dropped_vf
    failure :dropped_vf_already_transferred, fail_fast: true
    step :check_dropped_vf
    failure :dropped_vf_already_transferred, fail_fast: true
    step :find_or_create_auction
    step :create_bid
    step :create_notification
    failure :could_not_create_notification, fail_fast: true

    private

    def fetch_vf(options, params:, **)
      options['vf'] = VirtualFootballer.find(params[:virtual_footballer_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def vf_not_found(options)
      options['message'] = 'Bid on footballer not found!'
    end

    def fetch_vc(options, params:, **)
      options['vc'] = VirtualClub.find(params[:club_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def vc_not_found(options)
      options['message'] = 'Bidder club not found!'
    end

    def check_budget(options, params:, **)
      options['vc'].budget >= params[:money_offered]
    end

    def budget_not_enough(options)
      options['message'] = 'YOur club\'s budget is less than the offered cash!'
    end

    def check_club_capacity_next_gw(options, params:, **)
      drop_count = params[:virtual_engagement_to_drop_id].blank? ? 0 : 1
      if options['vc'].current_game_week.next_game_week.virtual_footballers.count -
          drop_count < options['vc'].league.squad_size
        true
      else
        false
      end
    end

    def club_capacity_full(options)
      options['message'] = 'This bid would put your club over league\'s squad
        limit in next game week\'s line up. Please drop a player!'
    end

    def fetch_dropped_ve(options, params:, **)
      return true if params[:virtual_engagement_to_drop_id].blank?
      options['ve'] = VirtualEngagement.
        find(params[:virtual_engagement_to_drop_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def dropped_ve_not_found(options)
      options['message'] = 'Dropped footballer does not exist!'
    end

    def check_dropped_vf(options, params:, **)
      return true if params[:virtual_engagement_to_drop_id].blank?
      !options['ve'].virtual_footballer.transferred?
    end

    def dropped_vf_already_transferred(options)
      options['message'] =
        'Dropped player is already outbound to another club next week!'
    end

    def find_or_create_auction(options, params:, **)
      options['auction'] = Auction.find_or_create_by(
        virtual_footballer_id: options['vf'].id,
        virtual_round_id: options['vc'].current_game_week.virtual_round.id
      )
    end

    def create_bid(options, params:, **)
      options['bid'] = Bid.create(
        auction_id: options['auction'].id,
        bidder_virtual_club_id: options['vc'].id,
        amount: params[:money_offered],
        dropped_virtual_footballer_id:
          params[:virtual_engagement_to_drop_id].present? ? options['ve'].virtual_footballer.id : nil
      )
    end

    def create_notification(options, params:, **)
      options['notification'] =
        Notification.create(
          league_id: options['bid'].bidder_virtual_club.league.id,
          recipient_id: options['bid'].bidder_virtual_club.user_id,
          sender_id: options['bid'].bidder_virtual_club.league.user_id,
          activity_type: Notification::ActivityTypes::WAVER_PENDING,
          object_type: options['bid'].class,
          object_id: options['bid'].id,
          content: "Your bid on #{options['vf'].footballer.name} (£#{params[:money_offered]}M) is pending",
          time_sent: Time.now
        )
    end

    def could_not_create_notification(options)
      options['message'] = 'Failed to Create Bid. Please try again!'
    end
  end
end
