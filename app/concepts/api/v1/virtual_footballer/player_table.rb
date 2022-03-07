# frozen_string_literal: true

require 'representable/json/hash'

module Api
  module V1
    module VirtualFootballer
      # api response using representer for all footballers in current season
      class PlayerTable < ::VirtualFootballer::Index
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection
          items class: ::VirtualFootballer do
            delegate :id, :name, :rating, :rank, :u_id, :cal_stat, :position,
              :current_club, :next_opponent, :away_match, to: 'represented.footballer'

            property :id
            property :name, as: :full_name, exec_context: :decorator
            property :rating, exec_context: :decorator
            property :rank, exec_context: :decorator
            property :u_id, as: :extid, exec_context: :decorator
            property :position, exec_context: :decorator
            property :status, as: :player_status
            property :points, exec_context: :decorator, render_nil: true
            def points
              represented.total_points.to_f
            end
            property :away_match, exec_context: :decorator, render_nil: true
            property :next_opponent,
              exec_context: :decorator,
              render_nil: true,
              decorator: ClubRepresenter
            property :virtual_club, as: :owner, exec_context: :decorator
            def virtual_club
              represented.virtual_club || {name: 'None'}
            end
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
                property :net_passes, as: :out_net_pass, exec_context: :decorator, render_nil: true
                property :tackles, render_nil: true
                property :interception, render_nil: true
                property :tackle_interception, exec_context: :decorator, render_nil: true
                property :discipline, exec_context: :decorator, render_nil: true
                property :goals_conceded, exec_context: :decorator, render_nil: true
                property :clean_sheets, exec_context: :decorator, render_nil: true
                # property :goals_conceded_points, exec_context: :decorator, render_nil: true
                property :take_ons, exec_context: :decorator, render_nil: true
                property :saves, render_nil: true
                property :saves_per_goal, exec_context: :decorator, render_nil: true

                def take_ons
                  return 0 unless represented.won_contest
                  represented.won_contest
                end
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

                def net_passes
                  if represented.accurate_pass
                    (represented.accurate_pass*2) - represented.total_pass
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

                def tackle_interception
                  represented.tackles + represented.interception
                end

                def clean_sheets
                  return 0 unless
                      %w[Goalkeeper Defender].include?(represented.footballer.position)

                  represented.clean_sheet
                end

                def goals_conceded_points
                  case represented.footballer.position
                    when 'Midfielder' then mid_goals_conceded_points
                    when 'Goalkeeper' then gk_def_goals_conceded_points
                    when 'Defender' then gk_def_goals_conceded_points
                    else
                      0
                  end
                end

                private

                def gk_def_goals_conceded_points
                  case
                  when represented.clean_sheet == 1 then 3
                  when represented.goals_conceded == 1 then 1
                  when represented.goals_conceded == 2 then 0
                  when represented.goals_conceded == 3 then -1
                  when represented.goals_conceded >= 4 then -3
                  else 0
                  end
                end

                def mid_goals_conceded_points
                  case
                  when represented.clean_sheet == 1 then 1
                  when represented.goals_conceded >= 4 then -1.0
                  when represented.goals_conceded == 3 then -0.5
                  else 0
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
