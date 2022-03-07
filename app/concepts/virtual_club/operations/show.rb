# frozen_string_literal: true

class VirtualClub < ApplicationRecord
  # show operation for virtual club
  class Show < Trailblazer::Operation
    extend Contract::DSL

    step Model(::VirtualClub, :find_by)
  end
end
