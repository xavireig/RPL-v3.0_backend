# frozen_string_literal: true

# store xml on application
class XmlFile < ApplicationRecord
  dragonfly_accessor :file

  # validates :file_name, :file_uid, presence: true
end
