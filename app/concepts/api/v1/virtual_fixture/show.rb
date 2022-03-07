# frozen_string_literal: true

module Api
  module V1
    module VirtualFixture
      # gets user's invites
      class Show < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          nested :round do
            property :id, exec_context: :decorator
            property :season_id, exec_context: :decorator
            property :number, exec_context: :decorator
            property :week, exec_context: :decorator
            property :is_done, exec_context: :decorator
            property :is_open, exec_context: :decorator
            property :full_status, exec_context: :decorator

            def id
              represented.virtual_round.round.id
            end

            def full_status
              represented.virtual_round.round.status
            end

            def number
              represented.virtual_round.round.number
            end

            def week
              represented.virtual_round.round.number
            end

            def season_id
              represented.virtual_round.league.season.id
            end

            def is_open
              represented.virtual_round.round.status == 'running'
            end

            def is_done
              represented.virtual_round.round.status == 'completed'
            end
          end
          property :home_score
          property :away_score
          property :home_virtual_club_id, as: :home_club_id
          property :away_virtual_club_id, as: :away_club_id

          property :home_virtual_club, as: :home_club do
            property :id
            property :name
            property :color1
            property :color2
            property :color3
            property :motto, render_nil: true
            property :abbr, render_nil: true
            property :stadium, render_nil: true
            property :user_id
            property :league_id
            nested :user do
              property :full_name, exec_context: :decorator

              def full_name
                represented.user.fname
              end
            end

            property :crest_pattern do
              property :id
              property :svg_url
              property :crest_shape_id, exec_context: :decorator
              def crest_shape_id
                represented.crest_shape.id
              end
            end
            property :rank, as: :place
            property :total_pts, as: :pts

            # uncommenting will calculate all scores dynamically from game week 1
            # property :place
            # property :data_tt_pts, as: :pts, exec_context: :decorator
            # def data_tt_pts
            #   represented.standing[:points]
            # end

          end

          property :away_virtual_club, as: :away_club do
            property :id
            property :name
            property :color1
            property :color2
            property :color3
            property :motto, render_nil: true
            property :abbr, render_nil: true
            property :stadium, render_nil: true
            property :league_id
            nested :user do
              property :full_name, exec_context: :decorator

              def full_name
                represented.user.fname
              end
            end

            property :crest_pattern do
              property :id
              property :svg_url
              property :crest_shape_id, exec_context: :decorator
              def crest_shape_id
                represented.crest_shape.id
              end
            end
            property :rank, as: :place
            property :total_pts, as: :pts

            # uncommenting will calculate all scores dynamically from game week 1
            # property :place
            # property :data_tt_pts, as: :pts, exec_context: :decorator
            # def data_tt_pts
            #   represented.standing[:points]
            # end
          end

          nested :home_line_up do
            property :matches_left_in_round_by_line_up, exec_context: :decorator

            def matches_left_in_round_by_line_up
              represented.home_club_footballers_left_to_start
            end
          end

          nested :away_line_up do
            property :matches_left_in_round_by_line_up, exec_context: :decorator

            def matches_left_in_round_by_line_up
              represented.away_club_footballers_left_to_start
            end
          end
        end
      end
    end
  end
end