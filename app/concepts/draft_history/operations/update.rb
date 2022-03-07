# frozen_string_literal: true

# draft history
class DraftHistory < ApplicationRecord
  # to update draft history
  class Update < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :virtual_footballer_id
      validates :id, presence: true
      validates :virtual_footballer_id, presence: true
      validates_uniqueness_of :virtual_footballer_id,
        uniqueness: { scope: :virtual_club_id }
    end

    step Model(::DraftHistory, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
