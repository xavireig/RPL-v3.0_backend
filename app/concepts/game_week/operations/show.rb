# frozen_string_literal: true

class GameWeek < ApplicationRecord
  # invite member to join league
  class Show < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::GameWeek, :find_by)
    failure :game_week_not_found, fail_fast: true

    private

    def game_week_not_found(options)
      options['message'] = 'Game Week not found!'
    end
  end
end
