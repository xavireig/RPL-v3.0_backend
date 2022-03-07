# frozen_string_literal: true

class Formation < ApplicationRecord
  # invite member to join league
  class Create < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :name
      property :league_id
      property :allowed
      validates :league_id, presence: true
      validates :name, presence: true
    end

    step Model(::Formation, :new)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
