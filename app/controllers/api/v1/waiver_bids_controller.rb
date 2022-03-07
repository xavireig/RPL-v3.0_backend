# frozen_string_literal: true

module Api
  module V1
    class WaiverBidsController < ApplicationController
      def create_waiver_bid
        result = ::Bid::Create.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message']}
        end
      end

      def bids_index
        result = VirtualClub::Show.call(params)
        if result.success?
          response =
            Api::V1::Bid::Index.
              call['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: 'Club not found'
          }
        end
      end

      def remove_bid
        result = ::Bid::Delete.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end

      def change_auction_date; end

      def apply_bid; end

      def hold_an_auction; end
    end
  end
end
