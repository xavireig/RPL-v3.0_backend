# frozen_string_literal: true

# MatchOfficial Model
class MatchOfficial < ApplicationRecord
  has_many :fixtures, through: :fixtures_match_officials
  has_many :fixtures_match_officials
end
