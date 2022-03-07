# frozen_string_literal: true

module Api
  module V1
    class MatchDayController < ApplicationController
      def full_virtual_fixture_data; end

      def full_virtual_fixture_data_from_cache
        virtual_fixture = ::VirtualFixture.find_by(id: params[:virt_fixture_id])
        representer = 'representer.render.class'
        response = VirtualFixture::Info.call[representer].new(virtual_fixture)
        render json: { success: 0, result: response }
      end

      def virtual_round_info
        virtual_round = ::VirtualRound.includes(
          virtual_fixtures: [
            :home_virtual_club,
            :away_virtual_club
          ]
        ).
          joins(:round).find_by(
            league_id: params[:league_id],
            rounds: { number: params[:week_num] }
          )
        representer = 'representer.render.class'
        response = VirtualRound::Show.call[representer].new(virtual_round)
        render json: { success: 0, result: response }
      end

      def round_info; end

      def fixtures_table; end

      def round_list
        league =
          ::League.includes(virtual_rounds: :round).order('rounds.number').
            find_by(id: params[:league_id])
        representer = 'representer.render.class'
        response = VirtualRound::Index.call[representer].new(league.virtual_rounds)
        render json: { success: 0, result: response }
      end

      def messages; end
    end
  end
end
