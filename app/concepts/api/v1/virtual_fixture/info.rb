# frozen_string_literal: true

module Api
  module V1
    module VirtualFixture
      # gets user's invites
      class Info < Trailblazer::Operation
        extend Representer::DSL

        representer :render do

          nested :vf,
            decorator: VirtualFixture::Show.call['representer.render.class'],
            class: ::VirtualFixture

          property :home_lineup,
            as: :home_line_up_full_data,
            getter: -> (represented:, **) {
              represented.virtual_round.game_weeks.find_by(virtual_club_id: represented.home_virtual_club_id)
            } do

            property :score,
              if: ->(represented:, **) { represented.score.is_a?(Hash) },
              render_filter: ->(input, _options) { OpenStruct.new(input) },
              as: :home_result, decorator: CategoryResultRepresenter
            collection :virtual_engagements,
              as: :full_virt_footballers,
              decorator: LineupRepresenter
          end

          property :away_lineup,
           as: :away_line_up_full_data,
           getter: -> (represented:, **) {
             represented.virtual_round.game_weeks.find_by(virtual_club_id: represented.away_virtual_club_id)
           } do
            property :score,
              if: ->(represented:, **) { represented.score.is_a?(Hash) },
              render_filter: ->(input, _options) { OpenStruct.new(input) },
              as: :away_result, decorator: CategoryResultRepresenter
            collection :virtual_engagements,
              as: :full_virt_footballers,
              decorator: LineupRepresenter
          end
        end
      end
    end
  end
end
