# frozen_string_literal: true

# message model
class Message < ApplicationRecord
  belongs_to :league
end
