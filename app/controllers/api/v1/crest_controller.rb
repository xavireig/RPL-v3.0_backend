# frozen_string_literal: true

module Api
  module V1
    class CrestController < ApplicationController
      # skip_before_action :authenticate_user!

      def shapes
        crest_shapes = ::CrestShape.includes(:crest_patterns).all
        response =
          CrestShape::Index.call['representer.render.class'].new(crest_shapes)
        render json: { success: 0, result: response }
      end

      def patterns; end
    end
  end
end
