# frozen_string_literal: true

module OptaParser
  #
  class StadiumParser
    #
    # constant
    #

    STADIUM_NON_SLAT_ATTRS = %w[Capacity Name].freeze

    #
    # includes
    #

    include ParserHelper

    def initialize(stadium_node)
      @stadium_node = stadium_node
    end

    def parse
      return {} if @stadium_node.nil?

      stadium = parse_node_attrs(@stadium_node)
      stadium.merge!(parse_attrs(@stadium_node, STADIUM_NON_SLAT_ATTRS))

      # ensure remove attr with nil value
      stadium.reject { |_, value| value.nil? }
    end
  end
end
