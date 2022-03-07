# frozen_string_literal: true

# wrapper module
module OptaParser
  # responsible for parsing result xml file
  class ResultFileParser
    #
    # includes
    #

    include ParserHelper

    #
    # attr reader
    #

    def initialize(xml_node)
      @xml_node = xml_node
    end

    # parse all teams
    def matches
      location = 'SoccerFeed/SoccerDocument/MatchData'

      @_teams ||=
        @xml_node.locate(location).map do |match|
          MatchParser.new(match).parse
        end
    end

    def soccer_feed
      parse_soccer_feed(@xml_node).reject { |_, value| value.nil? }
    end

    def soccer_document
      parse_soccer_document(@xml_node).reject { |_, value| value.nil? }
    end
  end
end
