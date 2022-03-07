# frozen_string_literal: true

module Api
  module V1
    module Fixture
      # to show individual draft order of a league
      class Index < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items(
            decorator: Fixture::Show.
              call['representer.render.class'],
            class: ::Fixture
          )
        end
      end
    end
  end
end
