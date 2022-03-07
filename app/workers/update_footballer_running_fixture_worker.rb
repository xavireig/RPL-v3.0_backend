# frozen_string_literal: true

# worker to update running fixture of footballers
class UpdateFootballerRunningFixtureWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    Rails.logger.info "========== <7>"
    footballers = Season.current_season.footballers
    Rails.logger.info "========== <8>"
    footballers.each do |f|
      f.update(running_fixture_id: f.current_fixture.id)
    end
  end
end
