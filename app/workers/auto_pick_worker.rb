# frozen_string_literal: true

# worker to auto pick footballer
class AutoPickWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :draft_queue

  def perform(draft_history_id)
    ::DraftHistory::AutoPick.call(id: draft_history_id)
  end
end
