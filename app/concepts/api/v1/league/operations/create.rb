# frozen_string_literal: true

module Api
  module V1
    module League
      # this operation creates a league
      class Create < ::League::Create
        extend Representer::DSL

        representer :render do
          include Representable::JSON

          property :id
          property :title
          property :draft_status
          property :draft_time
          property :invite_code, as: :uniq_code
          property :league_type
          # property :num_teams
          property :required_teams, as: :req_teams
          property :starting_round, as: :start_round_num
          property :match_numbers, as: :num_matches
          # property :max_round_num
          property :user_id
          property :scoring_type, as: :league_scoring_type
          # property :is_club
          # property :promotion order
          property :waiver_auction_day
          # property :ctc_transfers_deadline_round_number
          # property :league_settings_position
          property :auto_sub_enabled, as: :auto_subs
          property :squad_size
          property :double_gameweeks
          property :chairman_veto, as: :chairman_vetto
        end
      end
    end
  end
end
