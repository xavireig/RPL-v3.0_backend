# frozen_string_literal: true

# SquadsFileParser class is responsible for
# parsing all data from ox Document object
module OptaParser
  # responsible for parsing squad xml file
  class SquadsFileParser
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
    def teams
      location = 'SoccerFeed/SoccerDocument/Team'

      @_teams ||=
        @xml_node.locate(location).map do |team|
          TeamParser.new(team)
        end
    end

    def player_changes
      location = 'SoccerFeed/SoccerDocument/PlayerChanges/Team'

      @_changes ||=
        @xml_node.locate(location).map do |team|
          TeamParser.new(team)
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
