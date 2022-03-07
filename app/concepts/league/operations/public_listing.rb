# frozen_string_literal: true

class League < ApplicationRecord
  # to save league description
  class PublicListing < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      property :description
    end

    step Model(::League, :find_by)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
