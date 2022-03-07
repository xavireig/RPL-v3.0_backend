# frozen_string_literal: true

module OptaParser
  # parse player node
  class PlayerParser
    #
    # constant
    #

    PLAYER_NON_SLAT_ATTRS = %w[Name Position].freeze

    #
    # includes
    #

    include ParserHelper

    def initialize(player_node)
      @player_node = player_node
    end

    # parse player from squads.xml file
    def parse
      return {} if @player_node.nil?

      player_attr = parse_node_attrs(@player_node)
      player_attr.merge!(parse_attrs(@player_node, PLAYER_NON_SLAT_ATTRS))
      player_attr.merge!(parse_all_stats(@player_node))

      # ensure remove attr with nil value
      player_attr.reject { |_, value| value.nil? }
    end
  end
end
