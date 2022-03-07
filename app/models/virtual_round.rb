# frozen_string_literal: true

# virtual round model
class VirtualRound < ApplicationRecord
  belongs_to :round
  belongs_to :league
  has_many :game_weeks, dependent: :destroy
  has_many :virtual_fixtures, dependent: :destroy
  has_many :auctions, dependent: :destroy
  has_many :fixtures, through: :round
end
