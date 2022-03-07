# frozen_string_literal: true

# AR model
class FixturesMatchOfficial < ApplicationRecord
  belongs_to :fixture
  belongs_to :match_official
end
