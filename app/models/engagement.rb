# frozen_string_literal: true

# Engagement Model
class Engagement < ApplicationRecord
  belongs_to :footballer, touch: true
  belongs_to :club
  belongs_to :season
end
