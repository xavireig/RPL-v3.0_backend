# frozen_string_literal: true

# worker to calculate total points earned by league virtual footballers so far
class CalculateVirtualFootballerPtsForAllGwsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    VirtualFootballer.update_all(total_points: 0)
    leagues = League.includes(:virtual_clubs, :virtual_footballers).where(draft_status: 'completed', scoring_type: 'point')

    leagues.each do |l|
      # checking all clubs in a league has game weeks
      array = l.virtual_clubs.map { |vc| vc.current_game_week.nil? }
      next if array.include? true

      l.virtual_footballers.each do |vf|
        total_points = vf.completed_rounds_points
        vf.total_points = total_points
        vf.save
      end
    end
  end
end
