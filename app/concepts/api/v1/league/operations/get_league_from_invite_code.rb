# frozen_string_literal: true

module Api
  module V1
    module League
      # to show individual league information
      class GetLeagueFromInviteCode < ::League::GetLeagueFromInviteCode
        extend Representer::DSL

        representer :render do
          include Representable::JSON
          property :id
          property :title
          property :draft_status
          property :draft_time
          property :invite_code, as: :uniq_code
          property :num_teams, exec_context: :decorator
          property :required_teams, as: :req_teams
          property :starting_round, as: :start_round_num
          property :match_numbers, as: :num_matches
          property :max_round_num, exec_context: :decorator
          property :user_id
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
          property :club?, as: :is_club, exec_context: :decorator
          property :waiver_auction_day
          property :transfer_deadline_round_number,
            as: :ctc_transfers_deadline_round_number
          property :auto_sub_enabled, as: :auto_subs
          property :double_gameweeks
          property :chairman_veto, as: :chairman_vetto
          property :squad_size
          collection :invitations,
            as: :league_invites do
            property :id
            property :email
            property :status
            property :league_id
          end

          property :user do
            property :id
            property :provider
            property :email, as: :uid
            property :email
            property :fname
            property :lname
            property :full_name
            property :email_confirm?,
              as: :is_email_confirm,
              exec_context: :decorator

            def email_confirm?
              !represented.confirmed_at.nil?
            end
          end

          collection :formations,
            as: :league_settings_formations do
            property :id
            property :name, as: :formation
            property :allowed
          end

          collection :virtual_clubs, as: :clubs do
            property :id
            property :name
            property :stadium, render_nil: true
            property :motto, render_nil: true
            property :abbr, render_nil: true
            property :color1
            property :color2
            property :color3
            property :league_id, render_nil: true
            property :user_id
            property :crest_pattern_id
            property :crest_pattern do
              property :id
              property :name
              property :crest_shape_id
              property :svg_url
            end
            property :budget
            property :season, as: :season_id, exec_context: :decorator
            property :user, as: :owner do
              property :id
              property :provider
              property :email, as: :u_id
              property :email
              property :fname
              property :lname
              property :full_name
              property :email_confirm?,
                as: :is_email_confirm,
                exec_context: :decorator

              def email_confirm?
                !represented.confirmed_at.nil?
              end
            end

            def season
              current_season = ::Season.order(:created_at).last
              current_season.id
            end
          end
          property :transfer_budget
          property :league_type
          property :bonus_per_win
          property :bonus_per_draw

          def num_teams
            ::VirtualClub.where(league_id: represented.id).count
          end

          def max_round_num
            represented.match_numbers + represented.starting_round
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
