# frozen_string_literal: true

module Api
  module V1
    class MatchDayLeagueController < ApplicationController
      def short_stat_tbl; end

      def my_vf_data; end

      def news_by_league_or_club; end

      def news_by_footballer; end

      def my_club_in_league_stat; end

      def main_stat_tbl
        league = ::League.includes(:virtual_clubs).find(params[:league_id])
        virtual_clubs = league.virtual_clubs
        result =
          VirtualClub::LeagueStats.
            call['representer.render.class'].new(virtual_clubs)
        render json: { success: 0, result: result }
      end
    end
  end
end
