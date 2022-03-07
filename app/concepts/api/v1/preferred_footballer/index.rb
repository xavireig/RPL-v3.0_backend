# frozen_string_literal: true

module Api
  module V1
    module PreferredFootballer
      # to show individual draft order of a league
      class Index < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items(
            decorator: PreferredFootballer::Show.
              call['representer.render.class'],
            class: ::PreferredFootballer
          )
        end
      end
    end
  end
end
