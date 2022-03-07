# frozen_string_literal: true

module Api
  module V1
    module DraftOrder
      # to show individual draft order of a league
      class Show < ::Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          property :id
          property :league_id
          property :current_iteration, as: :cur_iter
          property :current_step, as: :cur_step_num
          property :queue, as: :club_queue_list
        end
      end
    end
  end
end
