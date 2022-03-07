# frozen_string_literal: true

# sum of drafting points for footballer
# per season
class Sdp < ApplicationRecord
  belongs_to :season
  belongs_to :footballer
end
