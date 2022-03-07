# frozen_string_literal: true

module Api
  module V1
    class LineUpController < ApplicationController
      def round_list; end

      def move_player
        representer = 'representer.render.class'
        result = ::VirtualEngagement::Swap.call(params)
        if result.success?
          response =
            GameWeek::Show.call[representer].new(result['model'].game_week)
          render json: { success: 0, result: response }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def change_line_up_format
        representer = 'representer.render.class'
        result = ::GameWeek::ChangeCurrentGwFormation.
          call(id: find_game_week.id, new_formation: params[:new_formation])
        if result.success?
          response =
            GameWeek::Show.call[representer].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def line_up_data
        representer = 'representer.render.class'
        game_week =
          ::GameWeek.includes(:virtual_engagements).find(find_game_week.id)
        if game_week
          response =
            GameWeek::Show.call[representer].new(game_week)
          render json: { success: 0, result: response }
        else
          render json: { success: 500, message: 'GameWeek not found!' }
        end
      end

      def line_up_data_for_club
        representer = 'representer.render.class'
        game_week = ::GameWeek.find(find_game_week.id)
        if game_week
          response =
            GameWeek::Show.call[representer].new(game_week)
          render json: { success: 0, result: response }
        else
          render json: { success: 500, message: 'GameWeek not found!' }
        end
      end

      def auto_sub
        result = ::GameWeek::ChangeAutoSub.call(params)
        if result.success?
          render json: {
            success: 200,
            message: result['message'],
          }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      private

      def find_game_week
        starting_round_number =
          ::VirtualClub.includes(:league).find(params[:virtual_club_id]).league.starting_round
        current_round_number = if params[:round_week_num].to_i < starting_round_number
                                 starting_round_number
                               else
                                 params[:round_week_num].to_i
                               end
        ::GameWeek.includes(:virtual_club, virtual_round: :round).
          where(
            rounds: {
              number: current_round_number
            },
            virtual_clubs: { id: params[:virtual_club_id] }
          ).first
      end
    end
  end
end
