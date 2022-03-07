# frozen_string_literal: true

require_relative 'mapper_helper'
require 'English'

# wrapper module
module OptaParser
  # mapper class: responsible for saving
  # squad file data
  class SquadMapper
    #
    # constant
    #

    COUNTRY_ATTRIBUTES =
      %i[country country_id country_iso region_id].freeze

    CLUB_ENGAGEMENT_ATTRS =
      %i[jersey_num real_position real_position_side join_date loan
         leave_date].freeze

    CLUB_CHANGE_ATTRS =
      %i[new_team].freeze

    FOOTBALLER_ATTRS = %i[
      u_id original_u_id first_name middle_name last_name name known_name
      birth_date birth_place first_nationality preferred_foot weight
      height country created_at updated_at position rank rating display_name
    ].freeze

    #
    # includes
    #

    include MapperHelper

    #
    # instance methods
    #

    def initialize(squad_obj)
      @_root = squad_obj
    end

    def save
      unless season.valid?
        msg = season.errors.full_messages
        OptaParser.prnt_e_log("invalid season #{msg}")

        # force return
        return
      end

      ::User.transaction do
        team_entry
        player_changes_entry
      end
    rescue => e
      print_error(e)
    end

    private

    # for passing rubocop issue
    # team on xml file is club on our application
    def team_entry
      @_root.teams.each do |team|
        club = club_from_attr(team.parse)

        # create players under team
        team.players.each do |player_attr|
          save_player(club, player_attr)
        end
      end
    end

    def player_changes_entry
      @_root.player_changes.each do |team|
        old_club = club_from_attr(team.parse)

        # club players changes
        team.players.each do |player_attr|
          save_change_player(old_club, player_attr)
        end
      end
    end

    # save player with association club
    def save_player(club, player_attrs)
      o_uid = player_attrs[:uid]

      footballer =
        Footballer.find_or_initialize_by(u_id: parse_uid(o_uid))
      footballer = update_footballer(
        footballer,
        player_attrs.slice(*FOOTBALLER_ATTRS),
        o_uid
      )

      # engagement
      player_engagement(footballer, club, player_attrs)
      save_position(footballer, player_attrs[:position])
    end

    # player changes, update old engagement
    def save_change_player(old_club, player_attrs)
      new_team_engagement(player_attrs)
      save_player(old_club, player_attrs.except(*CLUB_CHANGE_ATTRS)) if old_club
    end

    # take team attrs return AR club object
    def club_from_attr(club_attrs)
      # remove country's attribute from club
      club_attrs = club_attrs.reject { |k, _| COUNTRY_ATTRIBUTES.include?(k) }
      # save original uid and remove
      # uid key from attr
      o_uid = club_attrs[:uid]
      club_attrs.delete(:uid)
      # check existing club using u_id
      club = Club.find_or_initialize_by(u_id: parse_uid(o_uid))
      assign_club_with_season club
      club.attributes = club_attrs.merge(original_uid(o_uid))
      club.save!
      club # ensure return club
    end

    # assign current season into club
    def assign_club_with_season(club)
      club.seasons << season unless club.seasons.include?(season)
    end

    # save player's position
    # if last position is provided then skip
    def save_position(footballer, title)
      present_title = footballer.positions.last.try(:title)

      return if present_title && present_title == title

      footballer.positions.build(title: title)
    end

    # create player engagement with club
    def player_engagement(footballer, club, player_attrs)
      engagement =
        footballer.engagements.where(season: season, club: club).first
      if engagement.present?
        # update engagement attrs
        eng_attrs = player_attrs.slice(*CLUB_ENGAGEMENT_ATTRS)
        engagement.update_attributes(eng_attrs)
      else
        # create engagements
        create_engagement(footballer, club, player_attrs)
      end

      set_footballer_current_club_id(season, footballer.reload)
      mark_left_footballers(footballer.reload)
    end

    # update passing footballer with given attrs
    def update_footballer(footballer, player_attrs, o_uid)
      # remove uid and add original_u_id to attr
      attr_with_origin_uid =
        player_attrs.except(:uid).except(*CLUB_ENGAGEMENT_ATTRS).
          merge(original_uid(o_uid))

      if footballer.persisted?
        footballer.update_attributes(
          attr_with_origin_uid.slice(*FOOTBALLER_ATTRS)
        )
      else
        footballer.attributes = attr_with_origin_uid
      end
      footballer.save!
      footballer # ensure return footballer
    end

    def new_team_engagement(player_attrs)
      new_club =
        Club.find_by(name: player_attrs[:new_team])
      return unless new_club

      # new club's join data is old club's last date
      temp_attrs = player_attrs.clone
      temp_attrs[:join_date] = player_attrs[:leave_date]
      temp_attrs[:leave_date] = nil
      save_player(new_club, temp_attrs.except(*CLUB_CHANGE_ATTRS))
    end

    def create_engagement(footballer, club, player_attrs)
      eng_attrs = { footballer: footballer, season: season }.
        merge(player_attrs.slice(*CLUB_ENGAGEMENT_ATTRS))
      club.engagements.create!(eng_attrs)

      # create sdps
      footballer.sdps.create(season: season) unless
        Sdp.where(season: season, footballer: footballer).first
    end

    private

    def set_footballer_current_club_id(season, footballer)
      engagement =
        footballer.engagements.where(season: season).order(:join_date).last
      if engagement.loan
        footballer.update_column(:current_club_id, engagement&.club_id)
      else
        non_loan_engagement =
          footballer.engagements.where(loan: false).order(:join_date).last
        footballer.update_column(:current_club_id, non_loan_engagement&.club_id)
      end
    end

    def mark_left_footballers(footballer)
      footballer.update_column(:left, true) if footballer.left_epl?
    end
  end
end
