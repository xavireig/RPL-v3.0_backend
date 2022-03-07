# frozen_string_literal: true

module Api
  module V1
    class RealTeamsController < ApplicationController
      def index
        result = Club::RealTeamsList.call(params)
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: { success: 404, message: 'No League found!' }
        end
      end

      def real_teams_list
        result = Club::RealTeamsList.call(params)
        if result.success?
          response = result['representer.render.class'].new(result['model'])
          render json: { success: 0, result: response }
        else
          render json: { success: 404, message: 'No League found!' }
        end
      end
    end
  end
end
