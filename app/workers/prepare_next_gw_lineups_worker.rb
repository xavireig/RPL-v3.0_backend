# frozen_string_literal: true

# worker to replicate current game week's line up after last match of the round is played
class PrepareNextGwLineupsWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    leagues = League.includes(:virtual_clubs)

    leagues.each do |l|
      l.virtual_clubs.each do |vc|
        current_game_week = vc.current_game_week
        next if current_game_week.nil?
        GameWeek.transaction do
          game_weeks = GameWeek.tree_for(current_game_week)
          game_weeks.each do |gw|
            gw.virtual_engagements.destroy_all
            current_game_week.virtual_engagements.each do |ve|
              VirtualEngagement.create(
                game_week_id: gw.id,
                virtual_footballer_id: ve.virtual_footballer_id,
                status: ve.status
              )
            end
          end
          ::ChangeFormationWorker.perform_async(
            current_game_week.next_game_week.try(:id),
            current_game_week.formation.name
          )
        end
      end
    end
  end
end
