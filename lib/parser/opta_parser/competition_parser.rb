# frozen_string_literal: true

module OptaParser
  # CompetitionParser
  class CompetitionParser
    #
    # constant
    #

    COMPETITION_NON_SLAT_ATTRS = %w[Country Name].freeze

    #
    # includes
    #

    include ParserHelper

    def initialize(competition_node)
      @competition_node = competition_node
    end

    def parse
      return {} if @competition_node.nil?

      comp_attrs = parse_node_attrs(@competition_node)
      non_stat_attrs =
        parse_attrs(@competition_node, COMPETITION_NON_SLAT_ATTRS)
      comp_attrs.merge!(non_stat_attrs)
      comp_attrs.merge!(parse_all_stats(@competition_node))

      # ensure remove attr with nil value
      comp_attrs.reject { |_, value| value.nil? }
    end
  end
end
