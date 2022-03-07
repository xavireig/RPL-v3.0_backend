# frozen_string_literal: true

module Api
  module V1
    module VirtualClub
      # api response using representer for index of virtual clubs
      class Index < Trailblazer::Operation
        extend Representer::DSL

        representer :render do
          include Representable::JSON::Collection

          items class: ::VirtualClub do
            property :id
            property :name
            property :stadium, render_nil: true
            property :motto, render_nil: true
            property :abbr, render_nil: true
            property :color1
            property :color2
            property :color3
            property :league_id, render_nil: true
            property :league do
              property :id
              property :title
              property :draft_status
              property :invite_code, as: :uniq_code
              property :num_teams, exec_context: :decorator
              property :required_teams, as: :req_teams
              property :starting_round, as: :start_round_num
              property :user_id
              property :weight_goals_category
              property :fantasy_assist
              # property :league_sco_type
              property :club?, as: :is_club, exec_context: :decorator
              # property :promotion_order
              property :waiver_auction_day
              # property :ctc_transfers_deadline_round_number
              # property :league_settings_positions
              property :auto_sub_enabled, as: :auto_subs
              property :squad_size
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
            property :user_id
            property :crest_pattern_id
            property :crest_pattern do
              property :id
              property :name
              property :crest_shape_id
              property :svg_url
            end
            property :budget
            property :season_id, exec_context: :decorator

            def season_id
              represented&.league&.season&.id
            end

            property :user do
              property :id
              property :fname, as: :full_name
              property :lname
              property :email, render_nil: true
              property :is_email_confirmed, exec_context: :decorator

              def is_email_confirmed
                true
              end
            end
          end
        end
      end
    end
  end
end
