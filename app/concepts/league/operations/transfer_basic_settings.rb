# frozen_string_literal: true

class League < ApplicationRecord
  # invite member to join league
  class TransferBasicSettings < Show
    extend Contract::DSL

    contract do
      property :id
      property :bonus_per_win
      property :bonus_per_draw
      property :min_fee_per_addition
      property :transfer_budget
      property :chairman_veto
      validates :bonus_per_win, presence: true
      validates :bonus_per_draw, presence: true
      validates :min_fee_per_addition, presence: true
    end

    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
