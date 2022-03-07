class StartAuctionWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    leagues = League.all
    leagues.each do |league|
      Auction.transaction do
        ::Auction::Process.call(league_id: league.id)
      end
    end

    # close current round and open next round
    running_round = Season.current_season.running_round
    update_round_status(running_round)

    if running_round.next_round.present?
      open_next_round(running_round.next_round)
      UpdateFootballerRunningFixtureWorker.perform_async
    end
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

  def open_next_round(next_round)
    next_round.status = 1
    next_round.save
  end
end