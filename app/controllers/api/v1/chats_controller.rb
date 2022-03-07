# frozen_string_literal: true

module Api
  module V1
    class ChatsController < AuthController
      before_action :authenticate_user_from_token!
      before_action :set_league

      def index
        total_chats = @league.chats.count(:id)
        response = Chat::Index.call['representer.render.class'].new(chats)
        render json: { success: 0, total: total_chats, result: response }
      end

      private

      def set_league
        @league = ::League.find(params[:league_id])
      end

      def chat_params
        params.require(:chat).permit(:content)
      end

      def chats
        @league.chats.includes(:virtual_club).order('updated_at DESC').
          page(params[:page]).per(params[:per_page])
      end
    end
  end
end
