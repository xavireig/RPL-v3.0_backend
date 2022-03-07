# frozen_string_literal: true

# Fixture Model
class Fixture < ApplicationRecord
  attr_accessor :timestamp_accuracy_id, :timing_id, :tz, :matchwinner, :current_club

  has_many :statistics
  has_many :footballers, through: :statistics

  belongs_to :venue, class_name: 'Stadium'
  belongs_to :home_club,
    class_name: 'Club', foreign_key: 'home_club_id'

  belongs_to :away_club,
    class_name: 'Club', foreign_key: 'away_club_id'

  belongs_to :season
  has_many :fixtures_match_officials
  has_many :match_officials, through: :fixtures_match_officials
  belongs_to :home_club, class_name: 'Club', foreign_key: :home_club_id
  belongs_to :away_club, class_name: 'Club', foreign_key: :away_club_id
  belongs_to :round, touch: true

  def home_score
    score_by_club(home_club)
  end

  def away_score
    score_by_club(away_club)
  end

  def now_play
    Time.zone = 'London'
    date < Time.zone.now
  end

  def done?
    period == 'FullTime'
  end

  def ongoing?
    now_play || done?
  end

  def match_time
    date
  end

  private

  def score_by_club(club)
    goals_for = statistics.includes(footballer: :engagements).
      where(engagements: {
        season_id: Season.current_season,
        leave_date: nil,
        club_id: club
      }
      ).pluck(:goals).sum
    club = club == home_club ? away_club : home_club
    own_goals = statistics.includes(footballer: :engagements).
      where(engagements: {
        season_id: Season.current_season,
        leave_date: nil,
        club_id: club
      }
      ).pluck(:own_goals).sum
    goals_for.to_i + own_goals.to_i
  end
end
