# frozen_string_literal: true

module Api
  module V1
    module Invitation
      # gets user's all league invites based on filter
      class MyLeagueInvites < ::Invitation::MyLeagueInvites
        extend Representer::DSL
        representer :render do
          include Representable::JSON::Collection

          items class: ::Invitation do
            property :id
            property :status
            property :league_id
            property :league do
              property :id
              property :title
              property :draft_status
              property :draft_time
              property :invite_code, as: :uniq_code
              # property :num_teams
              property :required_teams, as: :req_teams
              property :starting_round, as: :start_round_num
              property :match_numbers, as: :num_matches
              property :max_round_num, exec_context: :decorator
              property :scoring_type, as: :league_scoring_type
              property :waiver_auction_day
              property :squad_size
              property :user do
                property :id
                property :email
                property :fname
                property :lname
                property :full_name, exec_context: :decorator
                property :email_confirm?, as:
                    :is_email_confirm, exec_context: :decorator

                def full_name
                  represented.fname + ' ' + represented.lname
                end

                def email_confirm?
                  !represented.confirmed_at.nil?
                end
              end

              property :weight_goals_category
              property :fantasy_assist
              nested :league_sco_type do
                property :id, as: :league_id
                property :scoring_type
                # property :is_cat_default, exec_context: :decorator
                # property :is_point_default, exec_context: :decorator

                # def is_cat_default
                #   (represented.scoring_type == 'category' &&
                #       represented.customized_scoring == true) ? false : true
                # end
                #
                # def is_point_default
                #   (represented.scoring_type == 'point' &&
                #       represented.customized_scoring == true) ? false : true
                # end
              end

              # collection :formations,
              #            as: :league_settings_formations do
              #   property :formation
              #   property :allowed
              # end

              property :auto_sub_enabled, as: :auto_subs
              property :double_gameweeks
              property :chairman_veto, as: :chairman_vetto
              # property :transfer_deadline_round_number,
              #          as: :ctc_transfers_deadline_round_number

              def max_round_num
                represented.match_numbers + represented.starting_round
              end
            end
          end
        end
      end
    end
  end
end
