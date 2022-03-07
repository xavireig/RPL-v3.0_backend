# frozen_string_literal: true

# Stadium Model
class Stadium < ApplicationRecord
  has_many :fixtures
end
