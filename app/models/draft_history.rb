# frozen_string_literal: true

# draft result model
class DraftHistory < ApplicationRecord
  belongs_to :virtual_club
  belongs_to :league
  belongs_to :virtual_footballer
end
