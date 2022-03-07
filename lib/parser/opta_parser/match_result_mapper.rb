# frozen_string_literal: true

require_relative 'mapper_helper'

# wrapper module
module OptaParser
  # mapper class: responsible for saving
  # squad file data
  class MatchResultMapper
    #
    # constant
    #

    STATE_ITEMS =
      %i[accurate_pass total_final_third_passes attempts_conceded_ibox
         total_fwd_zone_pass accurate_fwd_zone_pass ontarget_scoring_att
         lost_corners goals_conceded goals own_goals mins_played clean_sheet
         ontarget_att_assist goal_assist total_pass won_contest interception
         saves yellow_card red_card second_yellow won_corners big_chance_missed penalty_save
         penalty_miss penalty_conceded penalty_won error_lead_to_goal
         assist_handball_won assist_penalty_won assist_post touches
         assist_blocked_shot assist_pass_lost won_tackle jsonb fixture_id
         assist_attempt_saved footballer_id assist_own_goal turnover].freeze
    OFFICIAL_ATTRS = %i[first_name last_name u_id original_u_id].freeze
    #
    # includes
    #

    include MapperHelper

    #
    # instance methods
    #

    # @_root has been using to map helper method
    # if you change this, change to helper also
    def initialize(match_result_obj)
      @_root = match_result_obj
    end

    def save
      # Rails.logger.info '---------- with in Match ResultMapper save method'
      # Rails.logger.info "---- season #{season}"

      unless season.valid?
        msg = season.errors.full_messages
        Rails.logger.error ">>> invalid season #{msg}"

        # force return
        return
      end

      save_team_entry
      save_officials
      update_match
    end

    private

    def save_player_statistic(player, match, stats)
      statistic = player.statistics.find_or_initialize_by(fixture_id: match.id)
      statistic.attributes = stats.slice(*STATE_ITEMS)
      statistic.full_stat = stats.as_json
      begin
        statistic.save!
      rescue => e
        print_err_msg(e, statistic)
      end
    end

    # save team entries
    def save_team_entry
      @_root.teams_data.each do |team_obj|
        team_attrs = team_obj.parse
        u_id = parse_uid(team_attrs[:uid])
        match = Fixture.find_by(u_id: parse_uid(@_root.match_uid))

        team_obj.players.each do |player_attr|
          u_id = parse_uid(player_attr[:u_id])
          player = Footballer.find_by(u_id: u_id)
          save_player_statistic(player, match, player_attr) if player
        end
      end
    end

    # save officials and assistance officials
    def save_officials
      official_attrs = @_root.official
      match = Fixture.find_by(u_id: parse_uid(@_root.match_uid))
      # save main official
      Rails.logger.info "--- officials #{official_attrs.inspect}"
      save_official(official_attrs, match)

      # save assistance officials
      @_root.assistant_officials.each do |attrs|
        attrs[:first_name] = attrs[:firstname]
        attrs[:last_name] = attrs[:lastname]
        save_official(attrs, match)
      end
    end

    def save_official(official_attrs, match)
      Rails.logger.info "--- passing official attrs #{official_attrs.inspect}"
      o_uid = official_attrs[:uid]
      official = MatchOfficial.find_or_initialize_by(u_id: parse_uid(o_uid))
      official_attrs.merge!(original_uid(o_uid))
      official.attributes = official_attrs.slice(*OFFICIAL_ATTRS)
      official.fixtures_match_officials.
        build(fixture: match, o_type: official_attrs[:type])
      official.save!
    rescue => e
      OptaParser.prnt_e_log("MatchOfficial save fail for #{e}")
    end

    def update_match
      match = Fixture.find_by(u_id: parse_uid(@_root.match_uid))
      match.update_column(:period, @_root.match_info[:period])
      # prevent round status update depending on match status
      # update_round_status(match.round)
    end

    def update_round_status(round)
      round.update_column(
        :status,
        round_status(round.fixtures.where(period: 'PreMatch').count)
      )
    end

    def round_status(num)
      case num
      when 10 then Round.statuses[:pending]
      when 0 then Round.statuses[:completed]
      else Round.statuses[:running]
      end
    end
  end
end
