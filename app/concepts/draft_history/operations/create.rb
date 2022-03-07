# frozen_string_literal: true

# draft history
class DraftHistory < ApplicationRecord
  # to create draft history
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :iteration
      property :step
      property :league_id
      property :virtual_club_id
      validates :iteration, presence: true
      validates :step, presence: true
      validates :league_id, presence: true
      validates :virtual_club_id, presence: true
    end

    step Model(::DraftHistory, :new)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
