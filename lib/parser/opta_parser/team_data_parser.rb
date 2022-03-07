# frozen_string_literal: true

module OptaParser
  # parse TeamData of matchResult
  class TeamDataParser
    #
    # constant
    #

    TEAM_NON_SLAT_ATTRS = %w[Booking].freeze
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

      # teamref knowan as uid
      team_attr[:uid] = team_attr[:teamref]
      team_attr.delete(:teamref)

      # ensure remove attr with nil value
      team_attr.reject { |_, value| value.nil? }
    end

    def players
      location = 'PlayerLineUp/MatchPlayer'
      @_players ||=
        @team_node.locate(location).map do |player|
          stats = PlayerParser.new(player).parse

          # PlayerRef in here is the uid of the
          # player
          u_id = stats[:playerref]
          stats.delete(:playerref)
          stats[:u_id] = u_id
          stats
        end
    end
  end
end
