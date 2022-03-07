# frozen_string_literal: true

module Api
  module V1
    class AuthController < BaseApiController
      skip_before_action :authenticate_user_from_token!, except:
        %i[signout valid_auth_token delete_account]

      def try_forgot_password
        result = User::ForgetPassword.call(params)
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 401,
            message: result['model'].errors.full_messages.to_a.join(". \n")
          }
        end
      end

      def save_new_password
        result = User::SaveNewPassword.call(params)
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 401,
            message: result['model'].errors.full_messages.to_a.join(". \n")
          }
        end
      end

      def signup
        result = User::Create.call(params[:user])
        if result.success?
          sign_up_success(params, result)
        else
          render json: {
            success: 401,
            message: result['message']
          }
        end
      end

      def signin
        result = User::Signin.call(params[:user])
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 404,
            message: result['message']
          }
        end
      end

      def signout
        result = User::Signout.call(params)
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: { success: 404, message: 'Could not sign out' }
        end
      end

      def user_by_email
        result = User::Details.call(params)
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 404
          }
        end
      end

      def delete_account
        result = User::Delete.call(params)
        if result.success?
          render json: {
            success: 0,
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 404,
            message: result['contract.default'].errors.to_a.join(". \n")
          }
        end
      end

      def email_confirm
        result = User::Confirm.call(params)
        if result.success?
          render json: {
            success: 0,
            data: 'valid',
            result: result['representer.render.class'].new(result['model'])
          }
        else
          render json: {
            success: 404,
            message: result['contract.default'].errors.to_a.join(". \n")
          }
        end
      end

      def valid_auth_token
        render json: { success: 0 }
      end

      private

      def sign_up_success(params, result)
        VirtualClub::Create.call(
          params[:club].merge!(user_id: result['model'].id)
        )
        render json: {
          success: 0,
          result: result['representer.render.class'].new(result['model'])
        }
      end
    end
  end
end
