# frozen_string_literal: true

# worker to start auction process at Thursday UK 3PM
class AwardTransferBonusWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    virtual_rounds = VirtualRound.where(round_id: Season.current_season.running_round.id)
    virtual_rounds.each do |vr|
      VirtualClub.transaction do
        ::VirtualFixture::AwardBonus.call(vr: vr)
      end
    end

    StartAuctionWorker.perform_async
  end
end
