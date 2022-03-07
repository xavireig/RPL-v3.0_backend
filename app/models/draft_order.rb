# frozen_string_literal: true

# draft order model
class DraftOrder < ApplicationRecord
  belongs_to :league
end
