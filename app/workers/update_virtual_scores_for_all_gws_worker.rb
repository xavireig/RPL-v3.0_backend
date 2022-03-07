# frozen_string_literal: true

# worker to save the scores for the all completed virtual fixtures
class UpdateVirtualScoresForAllGwsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    leagues = League.includes(:virtual_clubs).where(draft_status: 'completed')

    leagues.each do |l|
      # checking all clubs in a league has game weeks
      array = l.virtual_clubs.map { |vc| vc.current_game_week.nil? }
      next if array.include? true

      l.virtual_clubs.each do |vc|
        virtual_fixtures = vc.completed_virtual_fixtures
        virtual_fixtures.each do |vf|
          vs = VirtualScore.find_or_initialize_by(virtual_fixture: vf)
          vs.update_attributes(
            home_score: vf.calculate_result(vf.home_game_week, vf.away_game_week),
            away_score: vf.calculate_result(vf.away_game_week, vf.home_game_week)
          )
        end
      end
    end
  end
end
