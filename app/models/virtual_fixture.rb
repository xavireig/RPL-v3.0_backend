# frozen_string_literal: true

# virtual fixture model
class VirtualFixture < ApplicationRecord
  #
  # associations
  #

  belongs_to :virtual_round
  belongs_to :home_virtual_club,
    class_name: 'VirtualClub', foreign_key: 'home_virtual_club_id'
  belongs_to :away_virtual_club,
    class_name: 'VirtualClub', foreign_key: 'away_virtual_club_id'
  has_many :fixtures, through: :virtual_round
  has_one :virtual_score

  #
  # instance methods
  #

  def home_score
    Rails.cache.fetch("#{id}-#{cache_key}/virtual_fixture/home_score", expires_in: 5.minutes) do
      virtual_score&.home_score || calculate_result(home_game_week, away_game_week)
    end
  end

  def away_score
    Rails.cache.fetch("#{id}-#{cache_key}/virtual_fixture/away_score", expires_in: 5.minutes) do
      virtual_score&.away_score || calculate_result(away_game_week, home_game_week)
    end
  end

  def win?(virtual_club_id)
    if(virtual_club_id == home_virtual_club_id)
      home_score > away_score
    else
      home_score < away_score
    end
  end

  def lost?(virtual_club_id)
    !win?(virtual_club_id)
  end

  def draw?
    home_score == away_score
  end

  def score(virtual_club_id)
    if(virtual_club_id == home_virtual_club_id)
      home_score
    else
      away_score
    end
  end

  def home_club?(virtual_club_id)
    virtual_club_id == home_virtual_club_id ? true : false
  end

  def home_club_footballers_left_to_start
    count = 0
    game_week = home_virtual_club.game_weeks.where(
      virtual_round_id: virtual_round_id
    ).first
    starting_xi = game_week.virtual_engagements.starting_xi
    starting_xi.map do |ve|
      fixture = ve.fixture
      count += 1 unless fixture&.done?
    end
    count
  end

  def away_club_footballers_left_to_start
    count = 0
    game_week = away_virtual_club.game_weeks.where(
      virtual_round_id: virtual_round_id
    ).first
    starting_xi = game_week.virtual_engagements.starting_xi
    starting_xi.map do |ve|
      fixture = ve.fixture
      count += 1 unless fixture&.done?
    end
    count
  end

  def calculate_result(own, opponent)
    return 0 if virtual_round.round.pending?
    league = own.league
    if league.scoring_type.eql?('point')
      own.score
    else
      settings = league.category_settings
      # settings['goal_conceded'] = settings.delete 'goals_conceded' if settings['goals_conceded'].present?
      own_score = own.score
      opponent_score = opponent.score
      own_score.keys.map do |category|
        if category == 'turnovers'
          opponent_score[category] > own_score[category] ?
            settings[category] : 0
        else
          own_score[category] > opponent_score[category] ?
            settings[category] : 0
        end
      end.compact.sum
    end
  end

  def home_game_week
    Rails.cache.fetch("#{id}-#{updated_at}/virtual_fixture/home_game_week", expires_in: 5.minutes) do
      GameWeek.
        includes(virtual_engagements: [virtual_footballer: [footballer: :current_club]]).
        where(virtual_club: home_virtual_club, virtual_round: virtual_round).first
    end
  end

  def away_game_week
    Rails.cache.fetch("#{id}-#{updated_at}/virtual_fixture/away_game_week", expires_in: 5.minutes) do
      GameWeek.
        includes(virtual_engagements: [virtual_footballer: [footballer: :current_club]]).
        where(virtual_club: away_virtual_club, virtual_round: virtual_round).first
    end
  end

  private

  def cache_key
    fixtures.order(updated_at: :desc).pluck(:updated_at).first
  end
end
