# frozen_string_literal: true

module Api
  module V1
    class LeagueDraftQueueController < ApplicationController
      def show
        representer = 'representer.render.class'
        result = ::DraftOrder.where(league_id: params[:league_id]).first
        if result.present?
          response =
            DraftOrder::Show.call[representer].new(result)
          render json: { success: 0, result: response }
        else
          render json: { success: 0, message: 'League has no draft order' }
        end
      end

      def update_clubs_order_in_queue; end
    end
  end
end
