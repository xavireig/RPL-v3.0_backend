class TransferActivity < ApplicationRecord
  belongs_to :league
  belongs_to :from_virtual_club,
    class_name: 'VirtualClub', foreign_key: 'from_virtual_club_id'
  belongs_to :to_virtual_club,
    class_name: 'VirtualClub', foreign_key: 'to_virtual_club_id'
  belongs_to :virtual_footballer

  def status
    return 'free' if !to_virtual_club.nil? && from_virtual_club.nil? && !auction
    return 'waiver' if to_virtual_club.nil? && !from_virtual_club.nil?
    return 'waiver' if !to_virtual_club.nil? && from_virtual_club.nil? && auction
    return 'trade' if !to_virtual_club.nil? && !from_virtual_club.nil? && amount.zero?
    return 'money' if amount.positive?
    return ''
  end
end
