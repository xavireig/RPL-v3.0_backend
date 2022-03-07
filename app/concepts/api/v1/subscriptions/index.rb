# frozen_string_literal: true

module Api
  module V1
    module Subscription
      # api response using representer for index of virtual clubs
      class Index < ::Subscription::Index
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: Braintree::Plan do
            property :id
            property :name
            property :description, as: :amount
          end
        end
      end
    end
  end
end
