# frozen_string_literal: true

# Generates draft order of all rounds for a league
class DraftOrder < ApplicationRecord
  # to get short draft status
  class ShortDraftStatus < Trailblazer::Operation
    extend Contract::DSL

    step :find_league
    failure :league_not_found, fail_fast: true
    step :draft_order_status
    step :current_iteration_and_step

    private

    def find_league(options, params:, **)
      league = ::League.find(params[:league_id])
      options['league'] = league
    rescue ActiveRecord::RecordNotFound
      false
    end

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def draft_order_status(options)
      options['draft_order'] = options['league'].draft_queue
    end

    def current_iteration_and_step(options, params:, **)
      league_id = options['league'].id
      time_to_end = fetch_time_to_end_step(league_id)
      options['draft_order'].merge!(
        current_step: options['league'].draft_order.current_step,
        current_iteration: options['league'].draft_order.current_iteration,
        time_to_end_step: fetch_time_to_end_step(league_id)
      )
    end

    def fetch_time_to_end_step(league_id)
      redis = Redis.new
      dnp = redis.get("#{league_id}_draft_next_pick")
      dnp.to_time - Time.current if dnp.present?
    end
  end
end
