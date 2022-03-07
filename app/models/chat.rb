# frozen_string_literal: true

# chat
class Chat < ApplicationRecord
  belongs_to :league
  belongs_to :virtual_club
end
