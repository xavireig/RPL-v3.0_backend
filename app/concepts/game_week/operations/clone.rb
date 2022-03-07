# frozen_string_literal: true

class GameWeek < ApplicationRecord
  # find next game week and make it clone of previous game week
  class Clone < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::GameWeek, :find_by)
    failure :game_week_not_found, fail_fast: true
    step :clone_virtual_engagements!
    step :clone_next_gw!

    private

    def game_week_not_found(options)
      options['message'] = 'Game Week not found!'
    end

    def clone_virtual_engagements!(options)
      VirtualEngagement.transaction do
        options['model'].previous_game_week.virtual_engagements.each do |ve|
          gw_ve = options['model'].virtual_engagements.where(
            game_week_id: options['model'].id,
            virtual_footballer_id: ve.virtual_footballer.id
          ).first
          if gw_ve.present?
            gw_ve.status = ve.status
            gw_ve.save
          end
        end
      end
    end

    def clone_next_gw!(options)
      ::GameWeek::Clone.call(id: options['model'].next_game_week.id) if
        options['model'].next_game_week.present?
    end
  end
end
