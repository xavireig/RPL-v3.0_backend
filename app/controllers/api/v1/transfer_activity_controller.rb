# frozen_string_literal: true

module Api
  module V1
    class TransferActivityController < ApplicationController
      def list_transfers
        league = ::League.find(params[:league_id])
      rescue ActiveRecord::RecordNotFound
        render json: { success: 500, message: 'League not found!'}
      else
        representer = 'representer.render.class'
        response = Api::V1::TransferActivity::Index.
          call[representer].new(league.transfer_activities)
        render json: { success: 0, result: response }
      end

      def list_trends; end

      def trends_footballers; end

      def club_transfers_count; end
    end
  end
end
