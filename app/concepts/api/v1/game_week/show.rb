# frozen_string_literal: true

module Api
  module V1
    module GameWeek
      # to show individual league information
      class Show < ::GameWeek::Show
        extend Representer::DSL
        include Representable::JSON::Collection

        representer :render do

          property :id
          property :virtual_club_id, as: :club_id
          property :auto_pick, exec_context: :decorator
          def auto_pick
            represented.auto_sub_on
          end
          property :formation, exec_context: :decorator
          def formation
            represented.formation.name
          end

          # === VIRTUAL FOOTBALLER SECTION ===
          collection :virtual_engagements, as: :virt_footballers do
            delegate :id, :footballer_id, :footballer, :round,
                     to: 'represented.virtual_footballer'

            property :id

            property :starting_xi?, as: :on_starting_xi
            property :benched?, as: :on_bench
            property :reserved?, as: :on_reserve

            property :block_for_action, exec_context: :decorator

            def block_for_action
              false
            end
            property :footballer_id, exec_context: :decorator
            property :footballer,
              render_filter: ->(input, represented:, **) {
                return input unless input

                  input.current_club =
                    represented.virtual_footballer.footballer.club(represented.round)
                  input
                },
              exec_context: :decorator, decorator: FootballerRepresenter
            property :game_role, as: :footballer_role_in_round

            # === MATCH DATA SECTION ===
            property :fixture, as: :match_data,
              render_filter: ->(input, represented:, **) {
                return input unless input

                input.current_club =
                  represented.virtual_footballer.footballer.club(represented.round)
                input
              },
              decorator: FixtureRepresenter

            # === V-ROUND SECTION ===
            property :virtual_round, as: :virt_round,
              exec_context: :decorator, decorator: VirtualRoundRepresenter

            def virtual_round
              represented.game_week.virtual_round
            end
          end # END OF V_F SECTION
        end
      end
    end
  end
end
