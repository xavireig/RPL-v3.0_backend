# frozen_string_literal: true

# league model
class League < ApplicationRecord
  # invite member to join league
  class BasicSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :title
      property :starting_round
      property :required_teams
      property :match_numbers
      validates :required_teams, presence: true
      validates :starting_round, presence: true
      validates :match_numbers, presence: true
    end

    step Model(::League, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end

  # to update draft settings
  class DraftTimeSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :time_per_pick_unit
      property :time_per_pick
      property :draft_time
      validates :time_per_pick_unit, presence: true
      validates :time_per_pick, presence: true
    end

    step Model(::League, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end

  # to update transfer settings
  class TransferDeadlineSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :transfer_deadline_round_number
      property :waiver_auction_day
      validates :waiver_auction_day, presence: true
    end

    step Model(::League, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end

  # to update league scoring type
  class ScoringTypeSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :scoring_type
      validates :scoring_type, presence: true
    end

    step Model(::League, :find_by)
    step :league_drafted?
    step :cannot_change_scoring_type, fail_fast: true
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    def league_drafted?(options)
      options['model'].draft_status.eql?('completed') ? false : true
    end

    def cannot_change_scoring_type(options)
      options['message'] =
        'You cannot change scoring type after league has drafted!'
    end
  end

  # to update scoring type
  class ScoringCustomizeSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :customized_scoring
    end

    step Model(::League, :find_by)
    step :league_drafted?
    failure :cannot_change_scoring_type, fail_fast: true
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    def league_drafted?(options)
      options['model'].draft_status.eql?('completed') ? false : true
    end

    def cannot_change_scoring_type(options)
      options['message'] =
        'You cannot change scoring type after league has drafted!'
    end
  end

  # to update formation type
  class FormationSettings < Trailblazer::Operation
    step :update_formation_settings!

    private

    def update_formation_settings!(_, params:)
      params[:formations].each do |formation|
        ::Formation::Update.call(formation)
      end
    end
  end

  # to update auto sub
  class SquadSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :auto_sub_enabled
      property :squad_size
    end

    step Model(::League, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end

  # to save transfer additional settings
  class TransferAdditionalSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :transfer_budget
      property :chairman_veto
    end

    step Model(::League, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end

  # to update scoring advanced options
  class ScoringAdvancedSettings < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :fantasy_assist
      property :weight_goals_category
    end

    step Model(::League, :find_by)
    step :league_drafted?
    failure :cannot_change_scoring_type, fail_fast: true
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    def league_drafted?(options)
      options['model'].draft_status.eql?('completed') ? false : true
    end

    def cannot_change_scoring_type(options)
      options['message'] =
        'You cannot change scoring type after league has drafted!'
    end
  end

  # to save draft order settings
  class DraftOrderSettings < Trailblazer::Operation
    step :update_draft_order!

    private

    def update_draft_order!(_, params:)
      ::DraftOrder::Update.call(params)
    end
  end
end
