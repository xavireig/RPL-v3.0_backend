# frozen_string_literal: true

# league controller
class League < ApplicationRecord
  # to create league
  class Clone < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :starting_round
      property :required_teams
      property :match_numbers
      property :season_id
      property :user_id
      property :title
      property :scoring_type
      property :draft_time
      property :custom_draft_order
      property :time_per_pick_unit
      property :time_per_pick
      property :league_type
      property :bonus_per_win
      property :bonus_per_draw
      property :transfer_budget
      property :chairman_veto
      property :category_scoring_settings
      property :point_scoring_settings
      property :auto_sub_enabled
      property :squad_size
      property :customized_scoring
      property :fantasy_assist
      property :weight_goals_category
    end

    step :find_league!
    step :sync!
    step Model(::League, :new)
    step :invite_code!
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
    step :clone_formations!
    step :assign_parent_league!
    step :assign_league_chairman!
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

    def find_league!(options, params:, **)
      options['parent_league'] = League.find_by(id: params[:parent_league_id])
    end

    def sync!(options, params:, **)
      ::League.column_names.each do |column|
        params[column.to_sym] = options['parent_league'][column.to_sym]
      end
    end

    def clone_formations!(options)
      parent_formations =
        options['parent_league'].formations
      parent_formations.each do |f|
        ::Formation::Create.call(
          name: f.name,
          league_id: options['model'].id,
          allowed: f.allowed
        )
      end
    end

    def assign_parent_league!(options)
      options['model'].parent_league =
        options['parent_league']
      options['model'].save!
    end

    def assign_league_chairman!(options, params:, **)
      options['model'].user_id = params[:chairman_id]
      options['model'].save!
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
      season = Season.find(options['model'].season_id)
      footballer_ids = season.footballers.map(&:id)
      CreateVirtualFootballerWorker.perform_async(
        options['model'].id,
        footballer_ids
      )
    end
  end
end
