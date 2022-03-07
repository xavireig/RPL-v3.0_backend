# frozen_string_literal: true

# subscription model
class Subscription < ApplicationRecord
  # constants
  TRIAL_DAYS = 14

  # subscription type
  # do not reorder this
  enum sub_type: %i[trial premium].freeze

  #
  # associations
  #

  belongs_to :user

  #
  # instance methods
  #
end
