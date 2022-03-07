# frozen_string_literal: true

# league model
class League < ApplicationRecord
  has_many :invitations, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :formations, dependent: :destroy
  has_many :allowed_formations, -> { where(allowed: true) },
    class_name: 'Formation'
  has_many :virtual_clubs, dependent: :destroy
  has_many :virtual_fixtures, through: :virtual_clubs, source: :home_virtual_fixtures
  has_many :members, through: :virtual_clubs, source: :user
  belongs_to :user
  belongs_to :season
  has_one :draft_order, dependent: :destroy
  has_many :draft_histories, dependent: :destroy
  has_one :latest_draft_history,
    (-> { where(virtual_footballer_id: nil) }),
    class_name: 'DraftHistory'
  has_many :chats, dependent: :destroy
  has_many :virtual_footballers, -> { joins(:footballer).where.not(footballers: { current_club_id: 62 }) }, dependent: :destroy
  has_many :preferred_footballers, through: :virtual_clubs
  has_many :virtual_rounds, dependent: :destroy
  delegate :current_iteration, :current_step, to: :draft_order
  has_one :sub_league, class_name: 'League', foreign_key: 'parent_league_id'
  belongs_to :parent_league, class_name: 'League'
  has_many :transfer_activities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one :running_virtual_round,
    (-> { where(round_id: Season.current_season.running_round.id) }),
    class_name: 'VirtualRound'

  # returns full draft order for this league for all rounds and steps
  def draft_queue
    # return @_draft_queue unless @_draft_queue.nil?
    draft_queue = {}
    (0...squad_size).each do |iter|
      order = iter.even? ? default_draft_order : default_draft_order.reverse
      draft_queue[iter] = { queue: order }
    end
    draft_queue
  end

  def current_drafting_club
    draft_queue.dig(current_iteration, :queue, current_step)
  end

  def category_settings
    if scoring_type.eql?('category')
      category_scoring_settings.select {|key, value| category_scoring_settings["#{key}_enabled"]}
    end
  end

  def point_settings
    if scoring_type.eql?('point')
      point_scoring_settings
    end
  end

  # do not use. method to check distribution of league fixtures against other clubs in the league
  def check_league_fixtures(virtual_club_id)
    vc = virtual_clubs.where(id: virtual_club_id).first
    fixture_count = {}
    all_virtual_fixtures = []
    virtual_rounds.each do |vr|
      all_virtual_fixtures.push(vr.virtual_fixtures)
    end

    all_virtual_fixtures.flatten!
    virtual_clubs.each do |vc|
      fixture_count[[vc.id, vc.name]] = {
          'home': all_virtual_fixtures.
            select { |vf| (vf.home_virtual_club_id.eql? virtual_club_id) && (vf.away_virtual_club_id.eql? vc.id) }.count,
          'away': all_virtual_fixtures.
            select { |vf| (vf.away_virtual_club_id.eql? virtual_club_id) && (vf.home_virtual_club_id.eql? vc.id) }.count
        }
    end

    fixture_count
  end

  private

  def default_draft_order
    default_order =
      VirtualClub.includes(:user).where(id: draft_order.queue).to_a
    draft_order.queue.map { |id| default_order.detect { |vc| vc.id == id } }
  end
end
