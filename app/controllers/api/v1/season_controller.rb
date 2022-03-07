# frozen_string_literal: true

module Api
  module V1
    class SeasonController < ApplicationController
      def index
        seasons = ::Season.order(u_id: :desc).all

        if seasons.present?
          render json: { success: 0, result: seasons }
        end
      end

      def cur_week_number
        render json: {
          success: 0,
          result: (current_season&.running_round&.number)
        }
      end

      def cur_season
        representer = 'representer.render.class'
        response =
          Season::CurrentSeason.call[representer].new(current_season)
        render json: { success: 0, result: response }
      end
    end
  end
end
