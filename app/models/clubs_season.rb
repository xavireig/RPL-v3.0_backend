# frozen_string_literal: true

# ClubsSeason Model
class ClubsSeason < ApplicationRecord
  belongs_to :club
  belongs_to :season
end
