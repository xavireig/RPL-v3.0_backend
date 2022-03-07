# frozen_string_literal: true

module Api
  module V1
    module VirtualFixture
      # gets user's invites
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::VirtualFixture do
            property :id
            # property :is_calc
            # property :last_calc
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
            end

            property :rpl_round_number, exec_context: :decorator
            def rpl_round_number
              (represented.virtual_round.round.number - represented.virtual_round.league.starting_round) + 1
            end
          end
        end
      end
    end
  end
end
