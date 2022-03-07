# frozen_string_literal: true

module Api
  module V1
    module League
      # to show individual league information
      class Show < ::League::Show
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :title
          property :description, render_nil: true
          property :league_type
          property :bonus_per_win
          property :bonus_per_draw
          property :transfer_budget

          property :draft_status
          property :draft_time
          property :invite_code, as: :uniq_code
          property :num_teams, exec_context: :decorator
          def num_teams
            ::VirtualClub.where(league_id: represented.id).count
          end
          property :required_teams, as: :req_teams
          property :starting_round, as: :start_round_num
          property :match_numbers, as: :num_matches
          property :max_round_num, exec_context: :decorator
          property :scoring_type, as: :league_scoring_type
          property :waiver_auction_day
          property :user do
            property :id
            property :email
            property :fname
            property :lname
            property :full_name, exec_context: :decorator
            property :email_confirm,
              as: :is_email_confirm,
              exec_context: :decorator

            def full_name
              represented.fname + ' ' + represented.lname
            end

            def email_confirm
              !represented.confirmed_at.nil?
            end
          end

          collection :virtual_clubs, as: :clubs do
            property :id
            property :name
            property :stadium
            property :motto
            property :abbr
            property :color1
            property :color2
            property :color3
            property :league_id
            property :crest_pattern_id
            property :crest_pattern do
              property :id
              property :svg_url
              property :crest_shape_id
            end
            property :user, as: :owner do
              property :id
              property :full_name, exec_context: :decorator
              property :email

              def full_name
                represented.fname + ' ' + represented.lname
              end
            end
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

          collection :allowed_formations,
            as: :league_settings_formations do
            property :id
            property :name, as: :formation
            property :allowed
          end

          property :squad_size
          property :auto_sub_enabled, as: :auto_subs
          property :double_gameweeks
          property :chairman_veto, as: :chairman_vetto
          property :transfer_deadline_round_number,
            as: :ctc_transfers_deadline_round_number,
            render_nil: true

          def max_round_num
            represented.match_numbers + represented.starting_round
          end

          collection :invitations,
            as: :league_invites do
            property :status
            property :email
          end
        end
      end
    end
  end
end
