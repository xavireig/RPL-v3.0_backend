# frozen_string_literal: true

# wrapper module
module OptaParser
  # parse official under team
  class MatchOfficialParser
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

      official_ref = @official_node.locate('OfficialData/OfficialRef').first
      official.merge!(parse_node_attrs(official_ref))

      official[:first_name] = first_name
      official[:last_name] = last_name

      # ensure remove attr with nil value
      official.reject { |_, value| value.nil? }
    end

    private

    def first_name
      @official_node.locate('OfficialName/First/^Text').first
    end

    def last_name
      @official_node.locate('OfficialName/Last/^Text').first
    end
  end
end
