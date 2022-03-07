# frozen_string_literal: true

module Api
  module V1
    module VirtualClub
      # api response using representer for index of virtual clubs
      class LeagueStats < Trailblazer::Operation
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

            # uncommenting will calculate all scores dynamically from game week 1
            # property :matches_played, exec_context: :decorator
            # property :data_tt_w, exec_context: :decorator
            # property :data_tt_d, exec_context: :decorator
            # property :data_tt_l, exec_context: :decorator
            # property :data_tt_pts, exec_context: :decorator
            # property :data_tt_score, exec_context: :decorator
            # property :form_str, exec_context: :decorator
            #
            # def matches_played
            #   represented.standing.slice(:win, :draw, :lost).values.sum
            # end
            #
            # def data_tt_w
            #   represented.standing[:win]
            # end
            #
            # def data_tt_d
            #   represented.standing[:draw]
            # end
            #
            # def data_tt_l
            #   represented.standing[:lost]
            # end
            #
            # def data_tt_pts
            #   represented.standing[:points]
            # end
            #
            # def data_tt_score
            #   represented.standing[:score]
            # end
            #
            # def form_str
            #   represented.standing[:form].last(5).join('-')
            # end

            property :matches_played, exec_context: :decorator
            property :total_win, as: :data_tt_w
            property :total_draw, as: :data_tt_d
            property :total_loss, as: :data_tt_l
            property :total_pts, as: :data_tt_pts
            property :total_score, as: :data_tt_score
            property :total_gd, as: :data_tt_gd, exec_context: :decorator
            property :form_str, exec_context: :decorator

            def matches_played
              represented.total_win + represented.total_loss + represented.total_draw
            end

            def form_str
              represented.form.last(5).join('-')
            end

            def total_gd
              total_gd = represented.total_gd
              total_gd.zero? ? total_gd : "%+d" % represented.total_gd
            end
          end
        end
      end
    end
  end
end
