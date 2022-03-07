# frozen_string_literal: true
# frozen_string_literal: true

module Api
  module V1
    class FootballersController < ApplicationController
      def index
        result = VirtualFootballer::Index.call(params)
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 404,
            message: result['message']
          }
        end
      end

      def players_table
        result = VirtualFootballer::PlayerTable.call(params)
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 404,
            message: result['message']
          }
        end
      end

      def player_stats
        ve = VirtualEngagement.find(params[:id])
        if ve.present?
          response =
            ::Api::V1::VirtualFootballer::PlayerStats.
              call['representer.render.class'].new(ve)
          render json: { success: 0, result: response }
        else
          render json: {
            success: 404,
            message: 'Footballer not found!'
          }
          end
      end

      def all_players_stats; end

      def footballer_team_color; end
    end
  end
end
