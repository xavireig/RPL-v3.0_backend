# frozen_string_literal: true

require_relative 'mapper_helper'

# wrapper module
module OptaParser
  # mapper class: responsible for saving
  # squad file data
  class ResultMapper
    #
    # constant
    #

    TEAM_ATTRS =
      %i[home_team country_id away_team].freeze
    # need to removed these from match attrs
    REMOVED_ATTRS = %i[uid matchtype].freeze
    ROUND_ATTRS = %i[matchday].freeze
    STADIUM_ATTRS = %i[venue venue_id city].freeze
    MATCH_ATTRS = %i[
      u_id original_u_id last_modified detail_id match_day postponed
      match_type period date home_club_id away_club_id
    ].freeze
    #
    # includes
    #

    include MapperHelper

    #
    # instance methods
    #

    # @_root has been using to map helper method
    # if you change this, change to helper also
    def initialize(result_obj)
      @_root = result_obj
    end

    def save
      Rails.logger.info '---------- with in ResultMapper save method'
      Rails.logger.info "---- season #{season}"

      unless season.valid?
        msg = season.errors.full_messages
        Rails.logger.error ">>> invalid season #{msg}"

        # force return
        return
      end

      match_entry
    end

    private

    # for passing rubocop issue
    # team on xml file is club on our application
    def match_entry
      @_root.matches.each do |match_attrs|
        match = match_from_attr(match_attrs)

        # save fixture
        begin
          match.save!
        rescue => e
          print_err_msg(e, match)
        end
      end
    end

    # take team attrs return AR club object
    def match_from_attr(match_attrs)
      match_attrs = map_club_attrs(match_attrs)
      match_attrs = map_match_day_type_attrs(match_attrs)
      # create or update match stadium
      stadium = stadium_from_attrs(match_attrs)
      create_or_update_match(match_attrs, stadium)
    end

    # stadium from attrs
    def stadium_from_attrs(attrs)
      uid = attrs[:venue_id]
      name = attrs[:venue]
      city = attrs[:city]

      stadium = Stadium.find_or_initialize_by(u_id: uid)
      stadium.attributes = { name: name, city: city, original_u_id: uid }
      stadium
    end

    # create home_club_id attr from uid
    # we get home_team, away_team from xml but
    # db field is home_club_id, away_club_id
    def map_club_attrs(match_attrs)
      # map home club id
      match_attrs[:home_club_id] =
        Club.find_by(u_id: parse_uid(match_attrs[:home_team])).try(:id)

      # parse away club id
      match_attrs[:away_club_id] =
        Club.find_by(u_id: parse_uid(match_attrs[:away_team])).try(:id)
      match_attrs
    end

    # create home_club_id attr from uid
    # we get matchday, matctype from xml but
    # db field is match_day, matc_type
    def map_match_day_type_attrs(match_attrs)
      # map home club id
      Rails.logger.info "#{'*' * 20} match_attrs #{match_attrs}"
      match_attrs[:match_day] = match_attrs[:matchday]

      # parse away club id
      match_attrs[:match_type] = match_attrs[:matchtype]
      match_attrs
    end

    def create_or_update_match(match_attrs, stadium)
      # save original uid and remove
      # uid key from attr
      o_uid = match_attrs[:uid]
      round_number = match_attrs[:matchday].to_i
      # accept only expected value
      match_attrs.slice!(*MATCH_ATTRS)

      Rails.logger.info "----- after removing uid #{match_attrs}"
      # check existing match using u_id
      match = Fixture.find_or_initialize_by(u_id: parse_uid(o_uid))
      match.venue = stadium

      # assign attribute to club
      match.attributes = match_attrs.merge(original_uid(o_uid))
      match.season = season
      match.round = round(round_number)
      match
    end

    def round(r_number)
      Round.find_or_create_by(number: r_number, season: season)
    end
  end
end
