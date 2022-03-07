# frozen_string_literal: true

module Api
  module V1
    module Season
      # for league general information
      class CurrentSeason < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :primary_u_id, exec_context: :decorator, as: :extid
          property :u_id, as: :extsid
          property :name
          property :round_shift, exec_context: :decorator

          def round_shift
            (represented.id - represented.id)
          end

          def primary_u_id
            represented.u_id
          end
        end
      end
    end
  end
end
