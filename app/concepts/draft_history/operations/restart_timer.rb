# frozen_string_literal: true

# draft history
class DraftHistory < ApplicationRecord
  # to restart draft timer
  class RestartTimer < Trailblazer::Operation
    step Model(::DraftHistory, :find_by)
    step :fetch_pick_time
    step :store_next_pick_time!
    step :broadcast_interval!

    def fetch_pick_time(options)
      options['pick_time'] = options['model'].virtual_club.pick_time
    end

    def store_next_pick_time!(options)
      redis = Redis.new
      redis.set(
        "#{options['model'].league_id}_draft_next_pick",
        Time.current + options['pick_time']
      )
    end

    def broadcast_interval!(options)
      ActionCable.server.broadcast(
        "draft_channel_league_#{options['model'].league.id}",
        type: 'restart_timer',
        time_to_end_step: options['pick_time']
      )
    end
  end
end
