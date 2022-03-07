# frozen_string_literal: true

class League < ApplicationRecord
  # to show league information
  class Show < Trailblazer::Operation
    extend Contract::DSL

    step Model(::League, :find_by)
  end
end
