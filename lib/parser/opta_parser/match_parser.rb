# frozen_string_literal: true

# warpper module
module OptaParser
  # parse match node
  class MatchParser
    #
    # constant
    #

    MATCH_NON_SLAT_ATTRS = %w[Attendance Date Result].freeze
    MATCH_INFO_NON_SLAT_ATTRS = %w[Date TZ].freeze

    #
    # includes
    #

    include ParserHelper

    def initialize(match_node)
      @match_node = match_node
    end

    def parse
      match_attr = parse_node_attrs(@match_node)
      match_info_node = @match_node.locate('MatchInfo').first
      match_attr.merge!(parse_node_attrs(match_info_node))
      match_attr.merge!(parse_attrs(match_info_node, MATCH_INFO_NON_SLAT_ATTRS))
      match_attr.merge!(parse_all_stats(@match_node))
      match_attr[:home_team] = home_team
      match_attr[:away_team] = away_team

      # ensure remove attr with nil value
      match_attr.reject { |_, value| value.nil? }
    end

    private

    def home_team
      @_home_team ||=
        parse_node_attrs(@match_node.locate('TeamData').first)[:teamref]
    end

    def away_team
      @_away_team ||=
        parse_node_attrs(@match_node.locate('TeamData').last)[:teamref]
    end
  end
end
