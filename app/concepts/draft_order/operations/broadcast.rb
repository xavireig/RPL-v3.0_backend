# frozen_string_literal: true

# Generates draft order of all rounds for a league
class DraftOrder < ApplicationRecord
  # to broadcast draft order after league join or removing teams from league
  class Broadcast < Trailblazer::Operation
    extend Contract::DSL

    step Model(::League, :find_by)
    failure :league_not_found, fail_fast: true
    step :draft_order_status
    step :current_iteration_and_step
    step :broadcast_draft_order

    private

    def league_not_found(options)
      options['message'] = 'League not found'
    end

    def draft_order_status(options)
      options['draft_order'] = options['model'].draft_queue
    end

    def current_iteration_and_step(options)
      options['draft_order'].merge!(
        current_step: options['model'].draft_order.current_step,
        current_iteration: options['model'].draft_order.current_iteration,
        time_to_end_step: fetch_time_to_end_step(options['model'].id)
      )
    end

    def broadcast_draft_order(options)
      ActionCable.server.broadcast(
        "draft_channel_league_#{options['model'].id}",
        type: 'update_draft_order',
        league: { data:
          {
            result: ::Api::V1::League::LeagueClubsListWithPattern.
              call['representer.render.class'].new(options['model'])
          } },
        draft_order: { data: { result: options['draft_order'] } }
      )
    end

    def fetch_time_to_end_step(league_id)
      redis = Redis.new
      dnp = redis.get("#{league_id}_draft_next_pick")
      dnp.to_time - Time.current if dnp.present?
    end
  end
end
