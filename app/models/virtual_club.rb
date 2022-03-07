# frozen_string_literal: true

# virtual club model
class VirtualClub < ApplicationRecord
  #
  # associations
  #

  belongs_to :league
  belongs_to :crest_pattern
  belongs_to :user # TODO: convert user to owner

  has_one :first_game_week, -> { where(parent_id: nil) },
          class_name: 'GameWeek'

  has_many :draft_histories, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_many :game_weeks, dependent: :destroy
  has_many :virtual_footballers, dependent: :destroy
  has_many :preferred_footballers, dependent: :destroy
  has_many :home_virtual_fixtures,
    class_name: 'VirtualFixture',
    foreign_key: 'home_virtual_club_id',
    dependent: :destroy
  has_many :away_virtual_fixtures,
    class_name: 'VirtualFixture',
    foreign_key: 'away_virtual_club_id',
    dependent: :destroy

  has_many :offered_transfer_offers,
           class_name: 'TransferOffer',
           foreign_key: 'sender_virtual_club_id'

  has_many :requested_transfer_offers,
           class_name: 'TransferOffer',
           foreign_key: 'receiver_virtual_club_id'

  has_many :bids, foreign_key: :bidder_virtual_club_id
  has_many :from_transfer_activities,
    class_name: 'TransferActivity',
    foreign_key: 'from_virtual_club_id',
    dependent: :destroy
  has_many :to_transfer_activities,
    class_name: 'TransferActivity',
    foreign_key: 'to_virtual_club_id',
    dependent: :destroy

  #
  # instance methods
  #

  def completed_virtual_fixtures
    all_fixtures_done ? post_fixture_league_standing : pre_fixture_league_standing
  end

  def current_game_week_fixtures
    current_game_week.virtual_round.virtual_fixtures.
      where(id: (home_virtual_fixture_ids + away_virtual_fixture_ids))
  end

  def game_week_fixtures(game_week)
    game_week.virtual_round.virtual_fixtures.
      where(id: (home_virtual_fixture_ids + away_virtual_fixture_ids))
  end

  def all_fixtures_done
    if current_game_week.virtual_round.round.number_of_pending_matches.eql?(0)
      true
    else
      false
    end
  end

  def completed_game_weeks
    GameWeek.includes(:virtual_club, virtual_round: :round).
      where(
        rounds: {
          status: 2
        },
        virtual_clubs: { id: id }
      )
  end

  def pre_fixture_league_standing
    VirtualFixture.
      joins(virtual_round: :round).
      where('rounds.status = ?', Round.statuses[:completed]).
      where(id: (home_virtual_fixture_ids + away_virtual_fixture_ids)).
      order('rounds.number')
  end

  def post_fixture_league_standing
    VirtualFixture.
      joins(virtual_round: :round).
      where('rounds.status != ?', Round.statuses[:pending]).
      where(id: (home_virtual_fixture_ids + away_virtual_fixture_ids)).
      order('rounds.number')
  end

  # calculates stats for all previous game weeks + current game week
  def standing
    return @_standing if @_standing.present?
    default = {
      points: 0,
      win: 0,
      draw: 0,
      lost: 0,
      score: 0,
      gd: 0,
      form: []
    }
    @_standing =
      completed_virtual_fixtures.each_with_object(default) do |fixture, memo|
        win = fixture.win?(self[:id])
        draw = fixture.draw?
        score = fixture.score(self[:id])
        home = fixture.home_club?(self[:id])
        if draw
          memo[:draw] += 1
        elsif win
          memo[:win] += 1
        else
          memo[:lost] += 1
        end
        memo[:points] +=
          if win
            3
          elsif draw
            1
          else
            0
          end
        memo[:score] += score
        memo[:gd] +=
          if home
            score - fixture.score(fixture.away_virtual_club_id).abs
          else
            score - fixture.score(fixture.home_virtual_club_id).abs
          end
        memo[:form].push(
          if win
            'W'
          elsif draw
            'D'
          else
            'L'
          end
        )
      end
  end

  # calculates stats for current game week fixtures
  def game_week_standing(game_week)
    return @_game_week_standing if @_game_week_standing.present?
    default = {
      points: 0,
      win: 0,
      draw: 0,
      lost: 0,
      score: 0,
      gd: 0,
      form: []
    }
    @_game_week_standing =
      game_week_fixtures(game_week).each_with_object(default) do |fixture, memo|
        win = fixture.win?(self[:id])
        draw = fixture.draw?
        score = fixture.score(self[:id])
        home = fixture.home_club?(self[:id])
        if draw
          memo[:draw] += 1
        elsif win
          memo[:win] += 1
        else
          memo[:lost] += 1
        end
        memo[:points] +=
          if win
            3
          elsif draw
            1
          else
            0
          end
        memo[:score] += score
        memo[:gd] +=
          if home
            score - fixture.score(fixture.away_virtual_club_id).abs
          else
            score - fixture.score(fixture.home_virtual_club_id).abs
          end
        memo[:form].push(
          if win
            'W'
          elsif draw
            'D'
          else
            'L'
          end
        )
      end
  end

  def place
    club_standing = Struct.new(:id, :pts, :score)
    clubs = []
    league.virtual_clubs.each do |vc|
      club_stats = vc.standing
      clubs.push(club_standing.new(vc.id, club_stats[:points], club_stats[:score]))
    end
    sorted = clubs.sort_by { |c| [c.pts, c.score, c.id] }.reverse
    sorted.index { |c| c.id == id } + 1
  end

  def game_week_place(game_week)
    club_standing = Struct.new(:id, :pts, :score)
    clubs = []
    league.virtual_clubs.each do |vc|
      club_stats = vc.game_week_standing(game_week)
      clubs.push(club_standing.new(vc.id, club_stats[:points] + vc.total_pts, club_stats[:score] + vc.total_score))
    end
    sorted = clubs.sort_by { |c| [c.pts, c.score, c.id] }.reverse
    sorted.index { |c| c.id == id } + 1
  end

  def pick_time
    reload
    auto_pick? || !user.is_online? ? 10 : convert_pick_time_to_seconds
  end

  def convert_pick_time_to_seconds
    if league.time_per_pick_unit == 'minutes'
      league.time_per_pick * 60
    elsif league.time_per_pick_unit == 'hours'
      league.time_per_pick * 3600
    else
      league.time_per_pick
    end
  end

  # this method should only be used for draft auto pick
  def count_footballers_by_type
    virtual_footballers.joins(:footballer).
      group('footballers.position').
      select('footballers.position, COUNT(*) as number').
      each_with_object(Hash.new(0)){ |r, h| h[r.position] = r.number }
  end

  def current_game_week
    game_weeks.includes(:virtual_round).
      where(
        virtual_rounds: {
          round_id: Season.current_season.running_round.id
        }
      ).first
  end

  def game_week_by_round(round_id)
    game_weeks.includes(:virtual_round).
      where(
        virtual_rounds: {
          round_id: round_id
        }
      ).first
  end

  def in(footballer_id)
    vf = league.virtual_footballers.where(footballer_id: footballer_id).first
    return if current_game_week.virtual_engagements.count >= league.squad_size
    return if VirtualEngagement.where(
      game_week_id: current_game_week.id,
      virtual_footballer_id: vf.id,
      status: 0
    ).present?
    vf.update_attribute(:virtual_club_id, id)
    VirtualEngagement.create(
      game_week_id: current_game_week.id,
      virtual_footballer_id: vf.id,
      status: 0
    )
    game_week_ids = GameWeek.tree_for(current_game_week).pluck(:id)
    game_week_ids.each do |gw|
      VirtualEngagement.create(
        game_week_id: gw,
        virtual_footballer_id: vf.id,
        status: 0
      )
    end
  end

  def out(footballer_id)
    vf = league.virtual_footballers.where(footballer_id: footballer_id).first
    vf.update_attribute(:virtual_club_id, nil)
    VirtualEngagement.find_by(
      game_week_id: current_game_week.id,
      virtual_footballer_id: vf.id
    ).destroy
    game_week_ids = GameWeek.tree_for(current_game_week).pluck(:id)
    VirtualEngagement.where(
      game_week_id: game_week_ids,
      virtual_footballer_id: vf.id
    ).destroy_all
    ::GameWeek::ChangeFormation.call(
      id: current_game_week.id,
      new_formation: current_game_week.formation.name
    )
  end
end
