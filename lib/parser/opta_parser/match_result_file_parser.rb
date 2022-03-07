# frozen_string_literal: true

# wrapper module
module OptaParser
  # parsing matchresult file
  class MatchResultFileParser
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

    def match_info
      @_match_node ||=
        @xml_node.locate('SoccerFeed/SoccerDocument/MatchData').first

      match_attr = parse_node_attrs(@_match_node)
      match_info_node = @_match_node.locate('MatchInfo').first
      match_attr.merge!(parse_node_attrs(match_info_node))
      match_attr.merge!(
        parse_attrs(match_info_node, MatchParser::MATCH_INFO_NON_SLAT_ATTRS)
      )
    end

    # parse match's team data
    def teams_data
      location = 'SoccerFeed/SoccerDocument/MatchData/TeamData'

      @_teams_data ||=
        @xml_node.locate(location).map do |team_data|
          TeamDataParser.new(team_data)
        end
    end

    def soccer_feed
      parse_soccer_feed(@xml_node).reject { |_, value| value.nil? }
    end

    def soccer_document
      # make sure this return season_id
      # that we are using with our shared code
      @_doc_attrs ||=
        parse_soccer_document(@xml_node).reject { |_, value| value.nil? }
      @_doc_attrs[:season_id] = competition[:season_id]
      @_doc_attrs[:season_name] = competition[:season_name]
      @_doc_attrs
    end

    def match_uid
      soccer_document[:uid]
    end

    def season_id
      competition[:season_id]
    end

    def competition
      location = 'SoccerFeed/SoccerDocument/Competition'
      competition_node = @xml_node.locate(location).first
      @_comp_attrs ||= CompetitionParser.new(competition_node).parse
      @_comp_attrs.reject { |_, value| value.nil? }
    end

    # array or match officials
    def official
      @_match_node ||=
        @xml_node.locate('SoccerFeed/SoccerDocument/MatchData').first

      # match has single official
      official_obj = @_match_node.locate('MatchOfficial').first
      @_official ||=
        MatchOfficialParser.new(official_obj).parse
    end

    # array of match assistance officials
    def assistant_officials
      @_match_node ||=
        @xml_node.locate('SoccerFeed/SoccerDocument/MatchData').first

      location = 'AssistantOfficials/AssistantOfficial'
      @_a_officials ||=
        @_match_node.locate(location).map do |a_official|
          parse_node_attrs(a_official)
        end
    end
  end
end
