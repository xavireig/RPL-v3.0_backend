# frozen_string_literal: true

module Api
  module V1
    module CrestShape
      # api response using representer for index of virtual clubs
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::CrestShape do
            property :id
            property :name
            property :svg_url
            collection :crest_patterns do
              property :id
              property :name
              property :crest_shape_id
              property :svg_url
            end
          end
        end
      end
    end
  end
end
