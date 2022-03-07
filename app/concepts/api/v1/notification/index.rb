# frozen_string_literal: true

module Api
  module V1
    module Notification
      # api response using representer for index of notifications
      class Index < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items(
            decorator: Notification::Show.
              call['representer.render.class'],
            class: ::Notification
          )
        end
      end
    end
  end
end
