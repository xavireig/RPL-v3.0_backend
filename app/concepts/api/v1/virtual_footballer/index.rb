# frozen_string_literal: true

require 'representable/json/hash'

module Api
  module V1
    module VirtualFootballer
      # api response using representer for all footballers in current season
      class Index < ::VirtualFootballer::Index
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection
          items class: ::VirtualFootballer do
            delegate :id, :name, :rating, :rank, :u_id, :birth_date, :adp,
              :cal_stat, :birth_place, :country, :position, :weight, :height,
              :current_club, :next_opponent, :away_match, to: 'represented.footballer'

            property :id
            property :adp, exec_context: :decorator
            property :name, as: :full_name, exec_context: :decorator
            property :rating, exec_context: :decorator
            property :rank, exec_context: :decorator
            property :u_id, as: :extid, exec_context: :decorator
            property :birth_date, exec_context: :decorator
            property :birth_place, exec_context: :decorator
            property :country, exec_context: :decorator
            property :position, exec_context: :decorator
            property :weight, exec_context: :decorator
            property :height, exec_context: :decorator
            property :status, as: :player_status
            property :away_match, exec_context: :decorator, render_nil: true
            property :next_opponent,
              exec_context: :decorator,
              render_nil: true,
              decorator: ClubRepresenter
            property :virtual_club, as: :owner, render_nil: true
            property :cal_stat,
              as: :footballer_stats_all_match, render_nil: true,
              exec_context: :decorator,
              wrap: false,
              render_filter: lambda { |input, options|
              hash = {}
              input.each do |value|
                hash[value[:season_id]] =
                    OpenStruct.new({ footballer: options[:represented].footballer }.merge(value))
              end
              hash
            } do
              include Representable::JSON::Hash
              values class: OpenStruct do
                property :season_id, render_nil: true
                property :points, render_nil: true
                property :goals, as: :int_goals, render_nil: true
                property :mins_played, as: :int_minutes, render_nil: true
                property :key_passes, as: :out_kpass, exec_context: :decorator, render_nil: true
                property :total_pass, as: :int_succ_passes, render_nil: true
                property :discipline, exec_context: :decorator, render_nil: true
                property :saves_per_goal, exec_context: :decorator, render_nil: true
                property :goals_conceded, exec_context: :decorator, render_nil: true
                property :clean_sheet, render_nil: true

                def goals_conceded
                  case represented.footballer.position
                  when 'Midfielder'
                    if represented.goals_conceded
                      represented.goals_conceded * -0.5
                    end
                  when 'Defender'
                    if represented.goals_conceded
                      represented.goals_conceded * -1
                    end
                  when 'Goalkeeper'
                    if represented.goals_conceded
                      represented.goals_conceded * -1
                    end
                  end
                end

                def key_passes
                  if represented.goal_assist
                    (represented.goal_assist * 2) +
                      represented.ontarget_att_assist
                  end
                end

                def discipline
                  if represented.yellow_card
                    (represented.yellow_card * -2) + (represented.red_card * -5)
                  end
                end

                def saves_per_goal
                  if represented.goals_conceded
                    if represented.goals_conceded.positive?
                      represented.saves / represented.goals_conceded
                    else
                      '∞'
                    end
                  end
                end
              end
            end

            property :current_club,
              as: :real_team,
              exec_context: :decorator do
              property :id
              property :u_id, as: :extid
              property :name
              property :short_club_name
            end

            # TODO : property :status related to injury and suspension
          end
        end
      end
    end
  end
end
