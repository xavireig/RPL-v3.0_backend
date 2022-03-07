# frozen_string_literal: true

class VirtualEngagement < ApplicationRecord
  # swap virtual engagement status of two footballers
  class Swap < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :to_id
      validates :to_id, presence: true
      validates :id, presence: true
    end

    step Model(::VirtualEngagement, :find_by)
    failure :virtual_engagement_not_found, fail_fast: true
    step :find_to_footballer
    failure :to_footballer_not_found, fail_fast: true
    step :match_day_started?
    failure :match_day_started, fail_fast: true
    step :swap!
    # Uncommenting this will swap the same players in all the next game week's
    # step :find_next_game_week
    # step :clone_game_week!
    # step :change_next_gw_formation!

    private

    def virtual_engagement_not_found(options, params:, **)
      options['message'] = "Footballer with #{params[:id]} not found!"
    end


    def find_to_footballer(options, params:, **)
      options['to_ve'] = VirtualEngagement.find(params[:to_id])
    rescue ActiveRecord::RecordNotFound
      false
    end

    def to_footballer_not_found(options, params:, **)
      options['message'] = "Footballer with #{params[:to_id]} not found!"
    end

    def match_day_started?(options)
      return false if options['model'].
          footballer.fixture_on_round(options['model'].
              game_week.virtual_round.round).ongoing? || options['to_ve'].
                  footballer.fixture_on_round(options['to_ve'].
                      game_week.virtual_round.round).ongoing?
      true
    end

    def match_day_started(options)
      options['message'] =
        'Sorry! You cannot swap footballers after their fixtures have started!'
    end

    def swap!(options)
      VirtualEngagement.transaction do
        from_status = options['model'].status
        options['model'].status = options['to_ve'].status
        options['model'].save
        options['to_ve'].status = from_status
        options['to_ve'].save
      end
    end

    def find_next_game_week(options)
      options['next_gw'] = options['model'].game_week.next_game_week
    end

    def clone_game_week!(options)
      ::ClonePreviousGameWeekWorker.perform_async(options['next_gw'].id) if
        options['next_gw'].present?
    end

    def change_next_gw_formation!(options)
      ::ChangeFormationWorker.perform_async(
        options['next_gw'].id,
        options['model'].game_week.formation.name
      )
    end
  end
end
