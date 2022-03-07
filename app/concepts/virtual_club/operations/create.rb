# frozen_string_literal: true

class VirtualClub < ApplicationRecord
  # operation for creating virtual club
  class Create < Trailblazer::Operation
    extend Contract::DSL
    contract do
      property :name
      property :user_id
      property :crest_pattern_id
      property :color1
      property :color2
      property :color3
      property :auto_pick
      property :motto
      property :abbr
      validates :user_id, presence: true
      validates :crest_pattern_id, presence: true
      validates :name, presence: true
    end

    step Model(::VirtualClub, :new)
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
