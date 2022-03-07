# frozen_string_literal: true

module OptaParser
  # TeamParser
  class TeamParser
    #
    # constant
    #

    TEAM_NON_SLAT_ATTRS = %w[Name Founded SYMID].freeze
    PLAYER_CHANGE_ATTRS = %w[new_team leave_date join_date].freeze

    #
    # includes
    #

    include ParserHelper

    def initialize(team_node)
      @team_node = team_node
    end

    # parse team node as hash
    def parse
      return {} if @team_node.nil?

      team_attr = parse_node_attrs(@team_node)
      team_attr.merge!(parse_attrs(@team_node, TEAM_NON_SLAT_ATTRS))

      # ensure remove attr with nil value
      team_attr.reject { |_, value| value.nil? }
    end

    def stadium
      stadium = @team_node.locate('Stadium').first
      @_stadium ||=
        StadiumParser.new(stadium).parse
    end

    def players
      @_players ||=
        @team_node.locate('Player').map do |player|
          PlayerParser.new(player).parse
        end
    end

    def officials
      location = 'TeamOfficial'

      @_officials ||=
        @team_node.locate(location).map do |official|
          TeamOfficialParser.new(official).parse
        end
    end

    def uid
      parse[:uid] && parse[:uid][1..-1].to_i
    end
  end
end
