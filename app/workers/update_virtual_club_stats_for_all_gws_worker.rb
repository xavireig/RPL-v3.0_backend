# frozen_string_literal: true

# worker to replicate current game week's line up after last match of the round is played
class UpdateVirtualClubStatsForAllGwsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    leagues = League.includes(:virtual_clubs).where(draft_status: 'completed')

    leagues.each do |l|
      # checking all clubs in a league has game weeks
      array = l.virtual_clubs.map { |vc| vc.current_game_week.nil? }
      next if array.include? true
      l.virtual_clubs.each do |vc|
        standing = vc.standing
        place = vc.place
        vc.update_attributes(
          total_pts: standing[:points],
          total_win: standing[:win],
          total_loss: standing[:lost],
          total_draw: standing[:draw],
          total_score: standing[:score],
          total_gd: standing[:gd],
          form: standing[:form],
          rank: place
        )
      end
    end
  end
end
