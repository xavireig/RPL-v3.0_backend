# frozen_string_literal: true

# league controller
class League < ApplicationRecord
  # to create league
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :starting_round
      property :required_teams
      property :match_numbers
      property :season_id
      property :user_id
      property :invite_code
      property :title
      property :scoring_type
      property :draft_status
      property :draft_time
      property :custom_draft_order
      property :time_per_pick_unit
      property :time_per_pick
      property :league_type
      validates :starting_round, presence: true
      validates :required_teams, presence: true
      validates :match_numbers, presence: true
      validates :season_id, presence: true
      validates :user_id, presence: true
      validates :invite_code, presence: true
      validates :title, presence: true
      validates :league_type, presence: true
    end

    step Model(::League, :new)
    step :current_season!
    step :invite_code!
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
    step :default_formation_settings!
    step :default_other_value!
    step :initialize_draft_order!
    step :create_virtual_footballer!

    private

    def invite_code!(options)
      options['model'].invite_code = generate_invite_code
    end

    def generate_invite_code
      loop do
        invite_code = SecureRandom.hex(8)
        break invite_code unless ::League.where(invite_code: invite_code).first
      end
    end

    def current_season!(options)
      options['season'] = Season.order(u_id: :desc).first
      options['model'].season_id = options['season'].id
    end

    def default_formation_settings!(options)
      formations = %w[f442 f433 f451 f352 f343 f541 f532]
      formations.each do |name|
        ::Formation::Create.call(
          name: name,
          league_id: options['model'].id,
          allowed: true
        )
      end
    end

    def default_other_value!(options)
      options['model'].transfer_budget = 25
      options['model'].time_per_pick = 60
    end

    def initialize_draft_order!(options)
      DraftOrder.create(
        current_iteration: 0,
        current_step: 0,
        league_id: options['model'].id,
        queue: []
      )
    end

    def create_virtual_footballer!(options)
      footballer_ids = options['season'].footballers.map(&:id)
      CreateVirtualFootballerWorker.perform_async(
        options['model'].id,
        footballer_ids
      )
    end
  end
end
