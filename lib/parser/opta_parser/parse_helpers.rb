# frozen_string_literal: true

module OptaParser
  # parser helper module contain all
  # helper method related to xml parsing
  module ParserHelper
    private

    # parse sourcefed
    def parse_soccer_feed(xml_obj)
      soccer_feed_nodes = xml_obj.locate('SoccerFeed')
      parse_node_attrs(soccer_feed_nodes.first)
    end

    def parse_soccer_document(xml_obj)
      soccer_document_nodes = xml_obj.locate('SoccerFeed/SoccerDocument')
      parse_node_attrs(soccer_document_nodes.first)
    end

    # return key:value pair from node
    def parse_stat(slat_node)
      return {} if slat_node.nil?

      stat = {}
      stat[slat_node.attributes[:Type].downcase.to_sym] =
        slat_node.locate('^Text').first
      stat
    end

    # parse given attrs
    # ex: <Player uID="p61566">
    #       <Name>lionel messi</Name>
    #       <Position>Striker Right Wing</Position>
    #     </Player>
    # if we pass ['Name', 'Position'] as attrs
    # we will get {:name => 'lionel messi', :position => 'Striker Right Wing'}

    def parse_attrs(node, attrs)
      attrs.each_with_object({}) do |attr, h|
        h[attr.downcase.to_sym] = node.locate("#{attr}/^Text").first
      end
    end

    # parse node's attribute
    # ex: <Player uID="p48844" Age="27" Country="bangladesh">
    # after parsing we will get:
    # {:uid => 'p48844', :age => '27', :country => 'bangladesh'}

    def parse_node_attrs(node)
      return {} if node.nil?

      node.attributes.keys.each_with_object({}) do |attr, h|
        h[attr.to_s.downcase.to_sym] = node.attributes[attr]
      end
    end

    def parse_all_stats(node)
      attrs = {}

      node.locate('Stat').each do |slat_obj|
        stat = parse_stat(slat_obj)
        attrs.merge!(stat)
      end

      attrs
    end
  end
end
