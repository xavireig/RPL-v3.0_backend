# frozen_string_literal: true

module Api
  module V1
    class LeagueInvitesController < BaseApiController
      before_action :authenticate_user_from_token!
      def index
        result = Invitation::Index.call(params)
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end

      def my_league_invites
        result = Invitation::MyLeagueInvites.call(
          params.merge(current_user: @current_user)
        )
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end

      def create
        result = Invitation::Invite.call(
          params.merge!(current_user: @current_user)
        )
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end

      def send_reminder; end

      def check_league_can_accept_invite
        result = ::Invitation::CheckLeagueCapacity.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end
    end
  end
end
