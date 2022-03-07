# frozen_string_literal: true

# worker to update round status based on number of not finished fixtures
class UpdateRoundStatusWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    running_round = Season.current_season.running_round
    update_round_status(running_round)
  end

  def update_round_status(round)
    round.update_column(
      :status,
      round_status(round.fixtures.where(period: 'PreMatch').count)
    )
  end

  def round_status(num)
    case num
      when 10 then Round.statuses[:pending]
      when 0 then Round.statuses[:completed]
      else Round.statuses[:running]
    end
  end
end