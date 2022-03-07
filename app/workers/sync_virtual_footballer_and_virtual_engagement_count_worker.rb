# frozen_string_literal: true

# worker to sync virtual footballers count with current game week virtual engagements count
class SyncVirtualFootballerAndVirtualEngagementCountWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :default

  def perform
    leagues = League.includes(:virtual_clubs).where(draft_status: 'completed')
    unsynced_vcs = []
    leagues.each do |l|
      l.virtual_clubs.each do |vc|
        unsynced_vcs.push(vc) if vc.current_game_week.present? && (vc.virtual_footballers.count > vc.current_game_week.virtual_engagements.count)
      end

      unsynced_vcs.each do |vc|
        extra_vf_ids = vc.virtual_footballers.pluck(:id) - vc.current_game_week.virtual_engagements.pluck(:virtual_footballer_id)
        extra_vf_ids.each do |evf_id|
          vf = VirtualFootballer.find evf_id
          vf.virtual_club_id = nil
          vf.save
        end
      end
    end
  end
end
