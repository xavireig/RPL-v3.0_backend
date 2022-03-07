# frozen_string_literal: true

# footballer Model
class Footballer < ApplicationRecord
  #
  # constants
  #

  TYPES =
    %w[Goalkeeper Defender Midfielder Forward].freeze

  #
  # associations
  #

  # TODO: need to improve queries instead of caching them
  attr_accessor :deceased
  has_many :engagements
  has_many :clubs, through: :engagements
  has_many :positions
  has_many :virtual_footballers
  has_many :statistics
  has_many :sdps
  has_one :current_sdp, -> { order(season_id: :desc) }, class_name: 'Sdp'
  has_many :fixtures, through: :statistics
  belongs_to :current_club, class_name: 'Club'
  belongs_to :running_fixture, class_name: 'Fixture'

  #
  # scopes
  #

  scope :goalkeepers, -> { where(position: 'Goalkeeper') }
  scope :forwards, -> { where(position: 'Forward') }
  scope :midfielders, -> { where(position: 'Midfielder') }
  scope :defenders, -> { where(position: 'Defender') }

  #
  # callbacks
  #

  after_create_commit :create_virtual_footballers, :update_running_fixture

  #
  # instance methods
  #

  def cal_stat
    Rails.cache.fetch("#{id}-#{updated_at}/statistics") do
      h_result = {}
      stats =
        statistics.joins(:fixture).group('fixtures.season_id').
        select(Statistic._select_column_sql + ', fixtures.season_id as season_id').map do |r|
        temp_data =
          Statistic.build_statistic(r).merge(season_id: r.season_id)
        h_result[temp_data[:season_id]] = temp_data
        end

      stat_with_default_val(stats)
    end
  end

  def cal_stat_by_week(week_number, season_id)
    Rails.cache.fetch("#{id}-#{updated_at}/statistics") do
      h_result = {}
      statistics.joins(fixture: :round).group(:round_id).
        where(rounds: { number: week_number, season_id: season_id }).
        select(Statistic._select_column_sql + ', round_id').map do |r|
        temp_data = Statistic.build_statistic(r).merge(round_id: r.round_id)
        h_result[temp_data[:season_id]] = temp_data
      end
    end
  end

  def old_current_club
    Rails.cache.fetch("#{id}-#{updated_at}/current_club") do
      engagements.includes(:club).
        where(season: Season.current_season, leave_date: nil).
        order(join_date: :desc).first.try(:club)
    end
  end

  def jersey_num
    Rails.cache.fetch("#{id}-#{updated_at}/jersey_num") do
      engagements.includes(:club).
        where(season: Season.current_season, leave_date: nil).
        pluck(:jersey_num).first
    end
  end

  def adp
    return rank if
      current_sdp.amount.zero?
    dc = ::Season.current_season.draft_count
    return 0 if dc.zero?
    (current_sdp.amount / dc.to_f).round(2)
  end

  def self.types
    %w[Goalkeeper Defender Midfielder Forward]
  end

  def home_match?(fixture)
    current_club_id == fixture.home_club_id
  end

  def away_match
    return false if running_fixture.nil?
    current_club_id == running_fixture.away_club_id if current_club
  end

  def stat_with_default_val(stats)
    season_ids = Season.pluck(:id)
    result = []

    season_ids.each do |s_id|
      t_val = stats.select{|s| s[:season_id] == s_id }.first
      result << (t_val.present? ? t_val : default_stat.merge(season_id: s_id))
    end

    result
  end

  def default_stat
    {
      goals: 0, mins_played: 0, points: 0, goal_assist: 0, total_pass: 0,
      accurate_pass: 0, take_ons: 0, yellow_card: 0, red_card: 0, tackles: 0,
      interception: 0, turnover: 0, saves: 0, ontarget_att_assist: 0,
      clean_sheet: 0, goals_conceded: 0,
    }
  end

  def next_opponent
    return nil if running_fixture.nil?
    if current_club_id.eql?(running_fixture.home_club_id)
      running_fixture.away_club
    else
      running_fixture.home_club
    end
  end

  def current_fixture
    current_round_fixtures.where('home_club_id =? OR away_club_id = ?', current_club_id, current_club_id).first
  end

  def current_round_fixtures
    Rails.cache.fetch("#{Season.current_season.running_round.id}/current_round_fixtures") do
      Season.current_season.running_round.fixtures
    end
  end

  def fixture_on_round(round)
    return nil unless club(round).present?
    round.fixtures.
      where('home_club_id =? OR away_club_id = ?', club(round).id, club(round).id).first
  end

  def left_epl?
    engagements.where(season: Season.current_season).order(:join_date).
      last&.leave_date.present?
  end

  def club(round = Season.current_season.running_round)
    Rails.cache.fetch("#{id}-round-#{round.id}-footballer-#{updated_at}/club") do
      engagement = engagements.where(season: round.season).where('join_date < ?', round.start_date).order(join_date: :desc).first
      engagement.present? ? engagement.club : nil
    end
  end

  def old_club
    engagements.where(season: Season.current_season).order(:leave_date).first.club
  end

  def create_virtual_footballers
    CreateVfForAllLeagueWorker.perform_async(id) unless left == true
  end

  def update_running_fixture
    update_attributes(running_fixture_id: current_fixture.id)
  end
end
