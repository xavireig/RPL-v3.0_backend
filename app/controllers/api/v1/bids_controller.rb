# frozen_string_literal: true

module Api
  module V1
    class BidsController < ApplicationController
      def create_team_to_team_bid
        result = ::TransferOffer::Create.call(
          params.merge(round: ::Season.current_season.running_round)
        )
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 400, message: result['message'] }
        end
      end

      def bids_index
        result = ::TransferOffer::Index.call(params, user: @current_user)
        if result.success?
          representer = 'representer.render.class'
          response = ::Api::V1::TransferOffer::Index.call[representer].
            new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: { success: 400, message: result['message'] }
        end
      end

      def user_requested_bids; end

      def reject_bid
        result = ::TransferOffer::Reject.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def accept_bid
        VirtualEngagement.transaction do
          result = ::TransferOffer::Accept.call(find_current_game_week)
          if result.success?
            render json: { success: 0 }
          else
            render json: { success: 500, message: result['message'] }
          end
        end
      end

      def revoke_bid
        result = ::TransferOffer::Delete.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def bids_admin_index
        result = ::TransferOffer::AdminIndex.call(params, user: @current_user)
        if result.success?
          representer = 'representer.render.class'
          response = ::Api::V1::TransferOffer::AdminIndex.call[representer].
            new(result['model'])
            render json: { success: 0, result: response, total: result['total']}
        else
          render json: { success: 400, message: result['message'] }
        end
      end

      def bids_admin_approve; end

      def bids_admin_veto; end

      private

      def find_current_game_week
        transfer_offer = ::TransferOffer.find(params[:id])
        game_week = transfer_offer.receiver_virtual_club.current_game_week
        {
          transfer_offer: transfer_offer,
          game_week: game_week
        }
      end
    end
  end
end
