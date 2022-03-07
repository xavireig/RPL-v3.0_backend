# frozen_string_literal: true

class League < ApplicationRecord
  # to start league draft
  class StartDraft < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::League, :find_by)
    failure :league_not_found, fail_fast: true
    step :league_full?
    failure :league_not_full, fail_fast: true
    step :draft_running?
    failure :draft_already_started, fail_fast: true
    step :draft_completed?
    failure :draft_already_completed, fail_fast: true
    step :change_draft_status!
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()

    private

    def league_not_found
      options['message'] = 'League not found'
    end

    def league_full?(options)
      options['model'].virtual_clubs.count == options['model'].required_teams
    end

    def league_not_full(options)
      options['message'] = 'Your league is not full yet!'
    end

    def draft_running?(options)
      !%w[running processing].freeze.include?(options['model'].draft_status)
    end

    def draft_already_started(options)
      options['message'] = 'You have already started draft once!
        Please refresh your browser!'
    end

    def draft_completed?(options)
      !options['model'].draft_status.eql?('completed')
    end

    def draft_already_completed(options)
      options['message'] = 'Draft for this league is already complete!'
    end

    def change_draft_status!(options)
      options['model'].draft_status = 'running'
    end

    def persist!(options)
      options['model'].save
    end
  end
end
