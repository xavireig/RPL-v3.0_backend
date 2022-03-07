# frozen_string_literal: true

# position settings model
class Formation < ApplicationRecord
  belongs_to :league
  has_many :game_weeks
end
