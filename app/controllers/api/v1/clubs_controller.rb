# frozen_string_literal: true

module Api
  module V1
    class ClubsController < AuthController
      # skip_before_action :authenticate_user!
      before_action :authenticate_user_from_token!

      def create
        result =
          VirtualClub::Create.call(
            params[:club].merge!(user_id: @current_user.id)
          )
        if result.success?
          success_response(result)
        else
          fail_response(result)
        end
      end

      def update
        result =
          VirtualClub::Update.call(params[:club].merge(id: params[:id]))
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: 'Club not found!'
          }
        end
      end

      def index
        virtual_clubs =
          ::VirtualClub.where(
            user_id: @current_user.id
          ).order('league_id DESC, created_at DESC')
        response =
          VirtualClub::Index.call['representer.render.class'].new(virtual_clubs)
        render json: { success: 0, result: response }
      end

      def list_of_user_clubs
        virtual_clubs =
          @current_user.virtual_clubs.order('league_id DESC, created_at DESC')
        representer = 'representer.render.class'
        response =
          VirtualClub::ListOfUserClub.call[representer].new(virtual_clubs)
        render json: { success: 0, result: response }
      end

      def show
        result = VirtualClub::Show.call(params)
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 500,
            message: 'Club not found'
          }
        end
      end

      def connect
        result = League::Join.call(
          params.merge!(current_user: @current_user)
        )
        if !result.success? && result['added_to_league_division']
          league_join_render 200, result

        elsif result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: {
            success: 0,
            result: response
          }
        else
          league_join_render 500, result
        end
      end

      def disconnect
        result = ::League::Detach.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def club_fixtures
        vc = ::VirtualClub.find(params[:id])
        if vc.present?
          league = vc.league
          response =
            ::Api::V1::VirtualFixture::Index.call['representer.render.class'].
              new(league.virtual_fixtures.joins(virtual_round: :round).
                where('home_virtual_club_id =? OR away_virtual_club_id = ?', vc.id, vc.id).
                order('rounds.number'))
          render json: { success: 0, result: response }
        else
          render json: { success: 500, message: 'Club not found!' }
        end
      end

      def club_stats; end

      def club_info
        vc = ::VirtualClub.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { success: 500, message: 'Club not found!'}
      else
        representer = 'representer.render.class'
        response = Api::V1::VirtualClub::Info.call[representer].new(vc)
        render json: { success: 0, result: response }
      end

      def take_free_agent
        VirtualEngagement.transaction do
          result = ::VirtualEngagement::Create.
            call(params.merge!(game_week_id: find_game_week.id))
          if result.success?
            render json: { success: 0 }
          else
            render json: { success: 399, message: result['message'] }
          end
        end
      end

      def drop_player
        representer = 'representer.render.class'
        VirtualEngagement.transaction do
          result = ::VirtualEngagement::Destroy.
            call(params.merge!(waiver: true))
          if result.success?
            response = ::Api::V1::GameWeek::Show.call[representer].new(result['game_week'])
            render json: { success: 0, result: response }
          else
            render json: { success: 500, message: result['message'] }
          end
        end
      end

      def check_unique
        result = ::VirtualClub::CheckUnique.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: {
            success: 400,
            message: 'You already have a club with that name from this season. \
                      Please choose another.'
          }
        end
      end

      private

      def league_join_render(code, result)
        render json: {
          success: code,
          message: result['message']
        }
      end

      def success_response(result)
        response = result['representer.render.class'].new(result['model'])
        render json: { success: 0, result: response }
      end

      def fail_response(result)
        render json: {
          success: 400,
          message: result['contract.default'].errors.to_a.join(". \n")
        }
      end

      def find_game_week
        starting_round_number =
          ::VirtualClub.includes(:league).find(params[:id]).league.starting_round
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
            virtual_clubs: { id: params[:id] }
          ).first
      end
    end
  end
end
