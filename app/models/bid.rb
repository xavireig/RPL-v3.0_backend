class Bid < ApplicationRecord
  #
  # associations
  #

  enum status: %i[pending lost won].freeze

  belongs_to :auction
  belongs_to :bidder_virtual_club, class_name: 'VirtualClub'
  belongs_to :dropped_virtual_footballer, class_name: 'VirtualFootballer'
end
