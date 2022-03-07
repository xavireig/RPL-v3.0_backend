# frozen_string_literal: true

class TransferActivity < ApplicationRecord
  # to send a transfer offer to a club
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :league_id
      property :virtual_round_id
      property :from_virtual_club_id
      property :to_virtual_club_id
      property :amount
      property :virtual_footballer_id
      property :auction
      validates :league_id, presence: true
      validates :virtual_round_id, presence: true
      validates :amount, presence: true
    end

    step Model(::TransferActivity, :new)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
