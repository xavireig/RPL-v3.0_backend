# frozen_string_literal: true

module Api
  module V1
    class ScoringTypeController < ApplicationController
      def index
        representer = 'representer.render.class'
        league = ::League.find(params[:league_id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::LeagueScoringType.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def set_scoring_type
        representer = 'representer.render.class'
        league = ::League.find(params[:league_id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::LeagueScoringType.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def scoring_type
        representer = 'representer.render.class'
        league = league_by_params params

        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::LeagueScoringType.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def set_scoring_is_def; end

      def reset_scoring_to_def
        representer = 'representer.render.class'
        result = League::DefaultScoring.call(params)
        if result.success?
          response =
            League::LeagueScoringType.call[representer].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: { success: 404, message: result['message'] }
        end
      end

      def league_scoring_type; end

      def sync_points_data
        representer = 'representer.render.class'
        result = League::SyncPointSettings.call(params)
        if result.success?
          response =
            League::LeagueScoringType.call[representer].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 404,
            message: result['message']
          }
        end
      end

      def sync_cats_data
        representer = 'representer.render.class'
        result = League::SyncCategorySettings.call(params)
        if result.success?
          response =
            League::LeagueScoringType.call[representer].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 404,
            message: result['message']
          }
        end
      end

      private

      def league_by_params(params)
        (params[:id].present? && ::League.find(params[:id]) ||
            ::League.find_by_invite_code(params[:code]))
      end
    end
  end
end
