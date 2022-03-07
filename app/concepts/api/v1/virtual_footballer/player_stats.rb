# frozen_string_literal: true

require 'representable/json/hash'

module Api
  module V1
    module VirtualFootballer
      # api response using representer for all footballers in current season
      class PlayerStats < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON
          delegate :footballer, to: 'represented.virtual_footballer'
          property :id
          property :starting_xi?, as: :on_starting_xi
          property :benched?, as: :on_bench
          property :reserved?, as: :on_reserve

          property :block_for_action, exec_context: :decorator

          def block_for_action
            false
          end
          property :virtual_footballer, as: :footballer do
            delegate :id, :name, :rating, :rank, :u_id, :birth_date,
              :birth_place, :country, :weight, :height, :jersey_num,
              :current_club, :first_name, :last_name, to: 'represented.footballer'

            property :id
            property :name, as: :full_name, exec_context: :decorator
            property :first_name, as: :fname, exec_context: :decorator
            property :last_name, as: :lname, exec_context: :decorator
            property :rating, exec_context: :decorator
            property :rank, exec_context: :decorator
            property :u_id, as: :extid, exec_context: :decorator
            property :birth_date, exec_context: :decorator
            property :birth_place, exec_context: :decorator
            property :country, exec_context: :decorator
            property :position, exec_context: :decorator
            def position
              represented.footballer.position.downcase
            end
            property :jersey_num, exec_context: :decorator
            property :weight, exec_context: :decorator
            property :height, exec_context: :decorator

            # Real Team section
            property :club_id, as: :real_team_id, exec_context: :decorator

            def club_id
              current_club.id
            end
            property :current_club,
              as: :real_team,
              exec_context: :decorator, decorator: ClubRepresenter

            # TODO : property :status related to injury and suspension

            # TODO : player_status
            # TODO :next opponent
            # TODO :current_stats
            # TODO :status, for example: Second Striker
            # TODO :owned_percentage
            # TODO :points
          end

          # VirtualClub-section
          property :virtual_club,
            as: :owner,
            decorator: VirtualClubRepresenter
          property :vf_status, as: :player_status, exec_context: :decorator

          def vf_status
            represented.virtual_footballer.status
          end
          # === MATCH DATA SECTION ===
          property :fixture, as: :match_data,
            decorator: FixtureRepresenter
        end
      end
    end
  end
end
