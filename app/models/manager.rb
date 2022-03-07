# frozen_string_literal: true

# Manager Model
class Manager < ApplicationRecord
  has_many :managers_club
  has_many :clubs, through: :managers_club
end
