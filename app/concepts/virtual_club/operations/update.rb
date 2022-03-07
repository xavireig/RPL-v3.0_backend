# frozen_string_literal: true

class VirtualClub < ApplicationRecord
  # update operation for virtual club which inherits show operation
  class Update < Show
    contract do
      property :id
      property :name
      property :crest_pattern_id
      property :color1
      property :color2
      property :color3
      property :auto_pick
      property :motto
      property :abbr
      property :stadium
    end
    step Contract::Build()
    step Contract::Validate()
    step Contract::Persist()
  end
end
