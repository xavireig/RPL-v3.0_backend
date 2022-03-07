# frozen_string_literal: true

# worker to auto pick footballer
class ChangeFormationWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :formation

  def perform(id, new_formation)
    GameWeek.transaction do
      ::GameWeek::ChangeFormation.call(id: id, new_formation: new_formation)
    end
  end
end
