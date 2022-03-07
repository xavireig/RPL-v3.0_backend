# frozen_string_literal: true

module Api
  module V1
    class LeagueSettingsController < ApplicationController
      def save_league_settings
        result = update_settings params
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 500,
            message: result['message']
          }
        end
      end

      private

      def update_settings(params)
        params[:settings_for_saving].each do |settings|
          method_name = "params_for_#{settings}"
          settings_class = "Api::V1::League::#{settings.camelize}"
          if private_methods.include?(method_name.to_sym)
            updated_params = send(method_name, params)
          end
          @result = settings_class.constantize.call(updated_params || params)
        end
        @result
      end

      def params_for_transfer_basic_settings(params)
        transfer_additional_settings =
          params[:tran_basic_settings][:trans_addit_set]

        params[:bonus_per_win] =
          params[:tran_basic_settings][:bonus_per_win]

        params[:bonus_per_draw] =
          params[:tran_basic_settings][:bonus_per_draw]

        params[:min_fee_per_addition] =
          params[:tran_basic_settings][:min_fee_per_add]

        params[:transfer_budget] =
          transfer_additional_settings[:annual_transfer_budget]

        params[:chairman_veto] =
          transfer_additional_settings[:chairman_vetto]
        params
      end

      def params_for_basic_settings(params)
        params[:title] = params[:league][:title]
        params[:starting_round] = params[:league][:start_round_num]
        params[:required_teams] = params[:league][:req_teams]
        params[:match_numbers] = params[:league][:num_matches]
        params
      end

      def params_for_transfer_deadline_settings(params)
        params[:transfer_deadline_round_number] =
          params[:club_to_club_transfer_deadline]
        params
      end

      def params_for_draft_time_settings(params)
        params[:draft_time] = params[:new_draft_time]
        params
      end

      def params_for_scoring_customize_settings(params)
        params[:customized_scoring] = !params[:is_default]
        params
      end

      def params_for_squad_settings(params)
        params[:auto_sub_enabled] = params[:auto_subs]
        params
      end

      def params_for_transfer_additional_settings(params)
        params[:transfer_budget] =
          params[:trans_addit_set][:annual_transfer_budget]

        params[:chairman_veto] =
          params[:trans_addit_set][:chairman_vetto]
        params
      end
    end
  end
end
