# frozen_string_literal: true

module Api
  module V1
    class LeaguesController < BaseApiController
      before_action only: :create do
        update_params_for_league_create(params)
      end
      skip_before_action :authenticate_user_from_token!,
        only: %I[leagues_info_link league_clubs_list_with_patterns]

      def create
        result = League::Create.call(params[:league])
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: {
            success: 400,
            message: result['contract.default'].errors.to_a.join(". \n")
          }
        end
      end

      def update; end

      def index
        representer = 'representer.render.class'
        all_leagues = @current_user.all_leagues
        if all_leagues.present?
          response =
            League::Index.call[representer].new(all_leagues).to_json(
              user_options: { current_user: @current_user }
            )
          render json: { success: 0, result: JSON.parse(response) }
        else
          render json: { success: 404, message: 'League not found!' }
        end
      end

      def show
        league = ::League.includes(virtual_clubs: %i[user crest_pattern]).
          find_by(id: params[:id])
        if league
          response = League::Show.call['representer.render.class'].new(league)
          render json: { success: 0, result: response }
        else
          render json: {
            success: 404,
            message: 'League is not found'
          }
        end
      end

      def public_leagues
        representer = 'representer.render.class'
        public_leagues =
          ::League.where(league_type: 'public')
        if public_leagues.blank?
          render json: { success: 404, message: 'No public Leagues found!' }
        else
          response =
            League::PublicLeagues.call[representer].new(public_leagues)
          render json: { success: 0, result: response }
        end
      end

      def league_draft_settings
        representer = 'representer.render.class'
        league = ::League.find(params[:id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::ShowDraftSettings.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def show_with_formations
        representer = 'representer.render.class'
        league = ::League.find(params[:id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::Show.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def league_squad_size
        league = ::League.find(params[:league_id])
        if league.present?
          render json: { success: 0, result: league.squad_size }
        else
          render json: { success: 500, message: 'The league is not found' }
        end
      end

      def start_draft
        result =
          ::League::StartDraft.call(params)
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def reject_invite
        result =
          ::Invitation::Reject.call(params.merge!(current_user: @current_user))
        if result.success?
          render json: { success: 0 }
        else
          render json: { success: 500, message: result['message'] }
        end
      end

      def leagues_code
        league = ::League.find(params[:id])
        if league.present?
          render json: {
            success: 0,
            result: league.invite_code,
            description: league.description
          }
        else
          render json: { success: 500, message: 'The league is not found' }
        end
      end

      def leagues_info_link
        result = League::GetLeagueFromInviteCode.call(params)
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

      def fin_status; end

      def set_fin_status; end

      def tran_basic_settings
        representer = 'representer.render.class'
        league = ::League.find(params[:id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::TransferBasicSettings.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def set_tran_basic_settings; end

      def tran_addit_setting
        representer = 'representer.render.class'
        league = ::League.find(params[:id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::TransferAdditionalSettings.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def set_tran_addit_setting; end

      def league_settings_formation; end

      def drop_league_settings_formation; end

      def add_league_settings_formation; end

      def league_settings_positions; end

      def league_clubs_list_with_patterns
        representer = 'representer.render.class'
        league = ::League.find(params[:league_id])
        if league.present?
          response =
            League::LeagueClubsListWithPattern.call[representer].new(league)
          render json: { success: 0, result: response }
        else
          render json: { success: 404, message: 'No League found!' }
        end
      end

      def league_clubs_list
        representer = 'representer.render.class'
        league = ::League.find(params[:id])
        if league.blank?
          render json: { success: 404, message: 'No League found!' }
        else
          response =
            League::LeagueClubs.call[representer].new(league)
          render json: { success: 0, result: response }
        end
      end

      def public_listing
        result = League::PublicListing.call(params)
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

      def set_league_draft_time; end

      def set_time_per_pick; end

      def league_base_info; end

      def set_transfer_deadlines; end

      def set_squad_settings; end

      def set_fixture_settings; end

      private

      def update_params_for_league_create(params)
        params[:league][:match_numbers] ||= params[:league][:num_matches]
        params[:league][:required_teams] ||= params[:league][:req_teams]
        params[:league][:starting_round] ||= params[:league][:start_round_num]
        params[:league][:user_id] ||= @current_user.id
        params[:league][:league_type] ||= params[:league][:league_type]
      end
    end
  end
end
