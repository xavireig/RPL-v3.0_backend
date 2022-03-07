# frozen_string_literal: true

# virtual engagement model
class VirtualEngagement < ApplicationRecord
  #
  # enum & constants
  #

  # TODO: if change this name change also to
  # game_week: D_METHODS_DEF
  enum status: %i[reserved benched starting_xi]

  #
  # delegates
  #

  delegate :club, to: :virtual_footballer
  delegate :footballer, to: :virtual_footballer
  delegate :virtual_club, to: :game_week
  delegate :league, to: :virtual_club
  delegate :round, to: :game_week

  #
  # associations
  #

  belongs_to :game_week
  belongs_to :virtual_footballer
  belongs_to :subbed_by, class_name: 'VirtualEngagement', foreign_key: 'subbed_id'
  has_one :subbed_with, class_name: 'VirtualEngagement', foreign_key: 'subbed_id'
  has_one :fixture, ->(object) {
    club_id = object.club(object.round)&.id
    where('home_club_id =? OR away_club_id=?', club_id, club_id) },
          through: :game_week, source: :fixtures

  # instance methods
  #

  def statistic
    @_statistic ||=
      fixture&.statistics&.where(footballer: virtual_footballer.footballer)&.first
  end

  def calculated_statistic
    if league.category_settings
      category_stat
    else
      points_stat
    end
  end

  def game_role
    if statistic.present?
      # TODO: takeout formation_place from full_stat to column
      statistic.full_stat['formation_place'].eql?('0') ? 'in_reserve' : 'in_game'
    else
      'unknown'
    end
  end

  private

  def category_stat
    # Rails.cache.fetch("#{id}-fixture-#{fixture&.id}-#{fixture&.updated_at}/virtual_engagement/category_stat") do
      types = league.category_settings
      types['accurate_pass'] = 0
      types['total_pass'] = 0
      # types['saves_percent_saves'] = 0 # for GK it is inf
      types['saves_percent_goals_conceded'] = 0


      types.map do |key, _value|
        [key, self.statistic.nil? ? dnp(key) : (self.statistic.send("cat_#{key}".to_sym).to_f)]
      end.to_h
    # end
  end

  def points_stat
    Rails.cache.fetch("#{id}-fixture-#{fixture&.id}-#{fixture&.updated_at}/virtual_engagement/points_stat") do
      types = league.point_scoring_settings[footballer.position.downcase]

      types.map do |key, value|
        self.statistic.nil? ? 0 : self.statistic.send("points_#{key}".to_sym).to_f * value.to_f
      end.sum
    end
  end

  # did not play penalty
  def dnp(key)
    return 0 unless footballer.fixture_on_round(game_week.virtual_round.round)&.ongoing?

    case key
    when 'goals_conceded' then dnp_goals_conceded(footballer.position)
    when 'goals_conceded_points' then dnp_goals_conceded_points(footballer.position)
    else 0
    end
  end

  def dnp_goals_conceded_points(position)
    case position
    when 'Midfielder' then -0.5
    when 'Goalkeeper' then -1
    when 'Defender' then -1
    else 0
    end
  end

  def dnp_goals_conceded(position)
    case position
    when 'Midfielder' then -1
    when 'Goalkeeper' then -2
    when 'Defender' then -2
    else 0
    end
  end
end
