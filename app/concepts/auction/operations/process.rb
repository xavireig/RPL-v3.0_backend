# frozen_string_literal: true

# Auction
class Auction < ApplicationRecord
  # to hold an auction for all the waiver bids in current round
  class Process < Trailblazer::Operation

    step :find_league
    step :fetch_running_virtual_round # for league
    step :reset_league_vfs
    step :fetch_auctions
    step :apply_bid_for_winner

    private

    def find_league(options, params:, **)
      options['league'] = League.find(params[:league_id])
    end

    def fetch_running_virtual_round(options)
      options['vr'] = options['league'].virtual_rounds.
        where(round_id: Season.current_season.running_round.id).first
    end

    def reset_league_vfs(options)
      options['league'].virtual_footballers.each do |vf|
        vf.waiver = false
        vf.transferred = false
        vf.save
      end
    end

    def fetch_auctions(options)
      options['auctions'] = Auction.
        where(processed: false, virtual_round_id: options['vr'].id)
    end

    def apply_bid_for_winner(options)
      options['auctions'].each do |auction|
        options['winning_bid'] = auction.winning_bid
        if options['winning_bid'].present?
          apply_bid_process = ::Auction::ApplyBid.call(winning_bid: options['winning_bid'])
          apply_bid_for_runner_up(options, auction) unless apply_bid_process.success?
        else
          auction.processed = true
          auction.save
        end
      end
    end

    def apply_bid_for_runner_up(options, auction)
      options['winning_bid'] = auction.runner_up_bid
      if options['winning_bid'].present?
        ::Auction::ApplyBid.call(winning_bid: options['winning_bid'])
      else
        auction.processed = true
        auction.save
      end
    end
  end
end
