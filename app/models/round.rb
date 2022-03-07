# frozen_string_literal: true

# Season Model
class Round < ApplicationRecord
  #
  # constants
  #

  enum status: %i[pending running completed]
  NUMBER_OF_MATCH = 10

  #
  # associations
  #

  has_many :fixtures
  belongs_to :season
  has_many :virtual_rounds
  has_one :next_round, class_name: 'Round', foreign_key: :parent_id
  belongs_to :previous_round, class_name: 'Round', foreign_key: :parent_id

  #
  # instance methods
  #

  def round_status
    num = number_of_pending_matches
    case num
    when 10 then Round.statuses[:pending]
    when 0 then Round.statuses[:completed]
    else Round.statuses[:running]
    end
  end

  def number_of_pending_matches
    fixtures.where(period: 'PreMatch').count
  end

  def all_fixtures_done?
    fixtures.where(period: 'PreMatch').count.eql?(0)
  end

  def start_date
    Rails.cache.fetch("#{id}-#{updated_at}/round/start_date") do
      fixtures.order(date: :asc).limit(1).first.date
    end
  end

  def pending?
    round_status == Round.statuses[:pending]
  end
end
