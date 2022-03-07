# frozen_string_literal: true

# crest shape model
class CrestShape < ApplicationRecord
  dragonfly_accessor :svg
  has_many :crest_patterns

  def svg_url
    svg.url
  end
end
