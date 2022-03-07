# frozen_string_literal: true

class VirtualFootballer < ApplicationRecord
  # this operation gets virtual footballer by its id
  class Show < Trailblazer::Operation
    extend Contract::DSL

    contract do
      property :id
      validates :id, presence: true
    end

    step Model(::VirtualFootballer, :find_by)
    failure :vf_not_found, fail_fast: true

    private

    def vf_not_found(options)
      options['message'] = 'Player not found!'
    end
  end
end
