# frozen_string_literal: true

# TODO: I am not sure this is best idea for loading
# lib/ code
require_relative '../../lib/parser/opta_parser'

# sidekiq worker
class CreateVfForAllLeagueWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :create_virtual_footballer

  def perform(footballer_id)
    Season.current_season.leagues.pluck(:id).each do |league_id|
      next if VirtualFootballer.where(league_id: league_id, footballer_id: footballer_id).present?

      VirtualFootballer.create!(
        league_id: league_id,
        footballer_id: footballer_id,
        waiver: true
      )
    end
  end
end
