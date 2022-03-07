# frozen_string_literal: true

module Api
  module V1
    module Subscription
      # api response using representer for index of virtual clubs
      class Create < ::Subscription::Create
        extend Representer::DSL

        representer :render do
          property :end_date, as: :endDate
          property :trial?, as: :isTrial, exec_context: :decorator

          def trial?
            represented.trial?
          end
        end
      end
    end
  end
end
