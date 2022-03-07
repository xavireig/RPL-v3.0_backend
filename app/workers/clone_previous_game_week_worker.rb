# frozen_string_literal: true

# worker to swap footballers in next game week
# Use this worker to replicate line up right away
class ClonePreviousGameWeekWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :formation

  def perform(id)
    GameWeek.transaction do
      ::GameWeek::Clone.call(id: id)
    end
  end
end
