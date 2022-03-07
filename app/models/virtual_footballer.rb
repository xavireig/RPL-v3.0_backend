# frozen_string_literal: true

# virtual footballer model
class VirtualFootballer < ApplicationRecord
  #
  # associations
  #

  belongs_to :league
  belongs_to :footballer
  belongs_to :virtual_club
  has_many :virtual_engagements, dependent: :destroy
  has_many :game_weeks, through: :virtual_engagements
  has_one :draft_history, dependent: :destroy
  has_many(
    :preferred_footballers,
    (-> { order(position: :asc) }),
    dependent: :destroy
  )

  has_and_belongs_to_many :offered_transfer_offers,
                          class_name: 'TransferOffer',
                          join_table: 'transfer_offers_offered_virtual_footballers'

  has_and_belongs_to_many :requested_transfer_offers,
                          class_name: 'TransferOffer',
                          join_table: 'transfer_offers_requested_virtual_footballers'
  has_many :auctions
  # user can drop same player in multiple bids
  has_many :bids
  has_many :transfer_activities, dependent: :destroy

  #
  # scopes
  #

  scope :available, (-> { where(virtual_club_id: nil) })

  #
  # delegate methods
  #

  delegate :adp, :rank, :club, :current_fixture, :fixture_on_round,
           to: :footballer, allow_nil: true

  #
  # instance methods
  #

  def status
    Time.zone = 'London'
    if footballer.running_fixture.nil? || footballer.left
      'left_epl'
    elsif transferred
      'Outbound'
    elsif virtual_club && !waiver
      'Owned'
    elsif waiver || footballer.running_fixture&.date < Time.zone.now
      'Waiver'
    else
      'Free Agent'
    end
  end

  def completed_rounds_points
    points = 0
    crs = Season.current_season.completed_rounds.order('number asc')
    crs.each do |cr|
      fixture = footballer.fixture_on_round(cr)
      next if fixture.nil?
      points += points_stat(fixture)
    end
    points
  end

  def points_stat(fixture)
    types = league.point_scoring_settings[footballer.position.downcase]

    types.map do |key, value|
      self.statistic(fixture).nil? ? 0 : self.statistic(fixture).send("points_#{key}".to_sym).to_f * value.to_f
    end.sum
  end

  def statistic(fixture)
    fixture&.statistics&.where(footballer_id: footballer_id)&.first
  end
end
