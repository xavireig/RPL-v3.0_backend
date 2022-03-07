# frozen_string_literal: true

module Api
  module V1
    class DraftController < AuthController
      before_action :authenticate_user_from_token!

      def player_to_queue; end

      def personal_queue
        virtual_club = ::VirtualClub.find(params[:virtual_club_id])
        vcpf =
          virtual_club.preferred_footballers.
            includes(:virtual_footballer).order(:position)
        response =
          PreferredFootballer::Index.call['representer.render.class'].new(vcpf)
        render json: { success: 0, result: response }
      end

      def rem_from_queue; end

      def move_in_queue; end

      def footballers_status; end

      def short_draft_status
        result =
          ::DraftOrder::ShortDraftStatus.call(
            params.merge!(current_user: @current_user)
          )
        if result.success?
          render json: { success: 0, result: result['draft_order'] }
        end
      end

      def full_draft_status; end

      def switch_auto_pick
        result =
          ::VirtualClub::ToggleAutoPick.call(
            params.merge!(current_user: @current_user)
          )
        if result.success?
          render json: {
            success: 0,
            result: { 'auto_pick': result['model'].auto_pick }
          }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end

      def result
        representer = 'representer.render.class'
        league = ::League.find(params[:league_id])
      rescue ActiveRecord::RecordNotFound
        render json: { success: 401, message: 'League not found' }
      else
        draft_history = league.draft_histories
        response = DraftHistory::Index.call[representer].new(draft_history)
        render json: {
          success: 0,
          result: response
        }
      end

      def take_footballer; end

      def undo; end

      def free_footballers_table; end
    end
  end
end
