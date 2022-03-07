# frozen_string_literal: true

# crest pattern model
class CrestPattern < ApplicationRecord
  dragonfly_accessor :svg
  has_many :virtual_clubs
  belongs_to :crest_shape

  def svg_url
    svg.url
  end
end
