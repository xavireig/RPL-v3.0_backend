# frozen_string_literal: true

# Club Model
class Club < ApplicationRecord
  # TODO: need to create country column
  # remove attr_reader after that

  #
  # attr_accessor, attr_reader
  #

  attr_accessor :country, :country_id, :symid, :official_club_name, :known_name

  #
  # associations
  #

  has_many :engagements
  has_many :footballers, foreign_key: :current_club_id
  has_many :managers_club
  has_many :managers, through: :managers_club
  has_and_belongs_to_many :seasons
  has_many :fixtures
end
