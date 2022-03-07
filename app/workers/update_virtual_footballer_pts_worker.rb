# frozen_string_literal: true

# worker to update total points earned by league virtual footballers in current game week
class UpdateVirtualFootballerPtsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    leagues = League.includes(:virtual_clubs, :virtual_footballers).
      where(draft_status: 'completed', scoring_type: 'point')


    leagues.each do |l|
      # checking all clubs in a league has game weeks
      array = l.virtual_clubs.map { |vc| vc.current_game_week.nil? }
      next if array.include? true
      l.virtual_footballers.each do |vf|
        fixture =
          vf.footballer.fixture_on_round(Season.current_season.running_round)
        next if fixture.nil?
        current_round_points = vf.points_stat(fixture)
        vf.total_points += current_round_points
        vf.save
      end
    end
  end
end
