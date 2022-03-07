# frozen_string_literal: true

# Season Model
class Season < ApplicationRecord
  has_and_belongs_to_many :clubs, -> { where.not(u_id: 0) }
  has_many :engagements, (-> { where(leave_date: nil) })
  has_many :fixtures, dependent: :destroy
  has_many :leagues, dependent: :destroy
  has_one :next_pending_round,
    (-> { where(status: Round.statuses[:pending]).order(number: :asc) }),
    class_name: 'Round'
  has_one :previous_completed_round,
    (-> { where(status: Round.statuses[:completed]).order(number: :desc) }),
    class_name: 'Round'
  has_many :rounds
  has_one :last_running_round,
    (-> { where(status: Round.statuses[:running]).order(number: :asc) }),
    class_name: 'Round'

  has_one :next_pending_round,
          (-> { where(status: Round.statuses[:pending]).order(number: :asc) }),
          class_name: 'Round'
  has_many :completed_rounds,
           (-> { where(status: Round.statuses[:completed]).order(number: :asc) }),
           class_name: 'Round'

  has_many :sdps, dependent: :destroy

  # throughs

  has_many :footballers, through: :clubs
  has_many :statistics, through: :fixtures

  scope :current_season, (-> { order(:u_id).last })

  def running_round
    last_running_round || next_pending_round || previous_completed_round || nil
  end
end
