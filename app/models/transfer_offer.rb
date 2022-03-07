class TransferOffer < ApplicationRecord
  #
  # constant & enum
  #

  enum status: %i[pending approved accepted rejected]

  #
  # associations
  #

  belongs_to :sender_virtual_club, class_name: 'VirtualClub'
  belongs_to :receiver_virtual_club, class_name: 'VirtualClub'
  has_one :transfer_activity, as: :transfer
  has_and_belongs_to_many :offered_virtual_footballers,
                          class_name: 'VirtualFootballer',
                          join_table: 'transfer_offers_offered_virtual_footballers'
  has_and_belongs_to_many :requested_virtual_footballers,
                          class_name: 'VirtualFootballer',
                          join_table: 'transfer_offers_requested_virtual_footballers'
end
