# frozen_string_literal: true

# Notification Model
class Notification < ApplicationRecord

  #
  # constants
  #

  enum status: %i[unread read]
  module ActivityTypes
    ACCEPT        = 'accept'
    CREATE        = 'create'
    REJECT        = 'reject'
    REVOKE        = 'revoke'
    WAVER_DELETE  = 'waver_bid_delete'
    WAVER_FAIL    = 'waver_bid_fail'
    WAVER_SUCCESS = 'waver_bid_success'
    WAVER_PENDING = 'waver_bid_pending'
  end

  #
  # associations
  #

  belongs_to :league
  belongs_to :recipient,
             class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender,
             class_name: 'User', foreign_key: 'sender_id'

  #
  # scopes
  #

  scope :unread, (-> { where(status: 0) })

  #
  # instance methods
  #

  def mark_as_viewed!
    update_attribute(:status, 1)
  end
end
