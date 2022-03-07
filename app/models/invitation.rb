# frozen_string_literal: true

# invitation model
class Invitation < ApplicationRecord
  belongs_to :league
end
