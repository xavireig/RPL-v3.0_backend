# frozen_string_literal: true

# wrapper module
module OptaParser
  # parse official under team
  class TeamOfficialParser
    #
    # constant
    #

    OFFICIAL_NON_SLAT_ATTRS = %w[BirthDate First Last join_date].freeze

    #
    # includes
    #

    include ParserHelper

    def initialize(official_node)
      @official_node = official_node
    end

    def parse
      return {} if @official_node.nil?

      official = parse_node_attrs(@official_node)
      person = @official_node.locate('PersonName').first
      official.merge!(parse_attrs(person, OFFICIAL_NON_SLAT_ATTRS))

      # ensure remove attr with nil value
      official.reject { |_, value| value.nil? }
    end
  end
end
