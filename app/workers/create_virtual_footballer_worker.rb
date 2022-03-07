# frozen_string_literal: true

# TODO: I am not sure this is best idea for loading
# lib/ code
require_relative '../../lib/parser/opta_parser'

# sidekiq worker
class CreateVirtualFootballerWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :create_virtual_footballer

  def perform(league_id, footballer_ids)
    footballer_ids.each do |footballer_id|
      VirtualFootballer.create!(
        league_id: league_id,
        footballer_id: footballer_id
      )
    end
  end
end
