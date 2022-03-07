# frozen_string_literal: true

# user model
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    :confirmable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable
  )

  has_many :virtual_clubs, dependent: :destroy
  has_many :leagues, dependent: :destroy
  has_many :invited_leagues,
    through: :virtual_clubs,
    source: :league,
    dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_many :received_notifications,
           class_name: 'Notification',
           foreign_key: 'recipient_id',
           dependent: :destroy
  has_many :sent_notifications,
           class_name: 'Notification',
           foreign_key: 'sender_id',
           dependent: :destroy

  def all_leagues
    @_all_leagues ||= (leagues + invited_leagues).uniq
  end

  def confirmation_required?
    !confirmed?
  end

  def appear!
    update_attribute(:is_online, true)
  end

  def disappear!
    update_attribute(:is_online, false)
  end
end
