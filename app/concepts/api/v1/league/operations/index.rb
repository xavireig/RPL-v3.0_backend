# frozen_string_literal: true

module Api
  module V1
    module League
      # for league general information
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          nested :my_leagues, render_filter: lambda { |input, options|
            input.select do |l|
              l.user.eql?(options[:options][:user_options][:current_user])
            end
          } do
            include Representable::JSON::Collection

            items class: ::League do
              property :id
              property :title
              property :description, render_nil: true
              property :league_type
              property :draft_status
              property :draft_time
              property :invite_code, as: :uniq_code # previous uniq_code
              property :num_teams, exec_context: :decorator
              property :required_teams, as: :req_teams
              property :starting_round, as: :start_round_num
              property :match_numbers, as: :num_matches
              property :max_round_num, exec_context: :decorator
              property :user_id
              property :scoring_type, as: :league_scoring_type
              property :club?, as: :is_club, exec_context: :decorator
              # property :promotion order
              property :waiver_auction_day
              property :transfer_deadline_round_number,
                as: :ctc_transfers_deadline_round_number

              def max_round_num
                represented.match_numbers + represented.starting_round
              end

              property :weight_goals_category
              property :fantasy_assist
              nested :league_sco_type do
                property :id, as: :league_id
                property :scoring_type
                property :category_default,
                  as: :is_cat_default,
                  exec_context: :decorator

                property :point_default,
                  as: :is_point_default,
                  exec_context: :decorator

                def category_default
                  !represented.customized_scoring
                end

                def point_default
                  !represented.customized_scoring
                end
              end

              property :squad_size
              property :auto_sub_enabled, as: :auto_subs
              property :double_gameweeks
              property :chairman_veto, as: :chairman_vetto

              def num_teams
                ::VirtualClub.where(league_id: represented.id).count
              end

              def club?
                club = ::VirtualClub.where(league_id: represented.id).first
                club.nil? ? false : true
              end
            end
          end
          nested :invited_leagues, render_filter: lambda { |input, options|
            input.reject do |l|
              l.user.eql?(options[:options][:user_options][:current_user])
            end
          } do
            include Representable::JSON::Collection

            items class: ::League do
              property :id
              property :title
              property :draft_status
              property :draft_time
              property :invite_code, as: :uniq_code
              property :num_teams, exec_context: :decorator
              property :required_teams, as: :req_teams
              property :starting_round, as: :start_round_num
              property :match_numbers, as: :num_matches
              # property :max_round_num
              property :user_id
              property :scoring_type, as: :league_scoring_type
              property :club?, as: :is_club, exec_context: :decorator
              # property :promotion order
              property :waiver_auction_day
              # property :ctc_transfers_deadline_round_number
              # property :league_settings_position
              property :auto_sub_enabled, as: :auto_subs
              property :double_gameweeks
              property :chairman_veto, as: :chairman_vetto

              def num_teams
                ::VirtualClub.where(league_id: represented.id).count
              end

              def club?
                club = ::VirtualClub.where(league_id: represented.id).first
                club.nil? ? false : true
              end
            end
          end
        end
      end
    end
  end
end
