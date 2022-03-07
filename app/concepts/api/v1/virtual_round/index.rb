# frozen_string_literal: true

module Api
  module V1
    module VirtualRound
      # gets user's invites
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection
          items class: ::VirtualRound do
            property :id
            property :season_id, exec_context: :decorator
            property :number, exec_context: :decorator
            property :is_done, exec_context: :decorator
            property :is_open, exec_context: :decorator
            property :status, exec_context: :decorator

            def status
              represented.round.status
            end

            def number
              represented.round.number
            end

            def season_id
              represented.league.season.id
            end

            def is_open
              represented.round.status == 'running'
            end

            def is_done
              represented.round.status == 'completed'
            end
          end
        end
      end
    end
  end
end
