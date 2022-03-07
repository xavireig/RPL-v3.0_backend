# frozen_string_literal: true

# formation model
class Formation < ApplicationRecord
  # to update formation settings
  class Update < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :name
      property :allowed
      validates :name,
        presence: true,
        inclusion: {
          in: %w[f442 f433 f451 f352 f343 f541 f532]
        }
    end

    step Model(::Formation, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
