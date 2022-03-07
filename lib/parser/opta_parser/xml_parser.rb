# frozen_string_literal: true

# XmpParser responsible for parsing xml
module OptaParser
  # xml parser
  class XmlParser
    #
    # constant
    #

    RETRY_TIMES = 3

    #
    # instance methods
    #

    def initialize(xml_file_path, file_name)
      @file_name = file_name
      @file_path = xml_file_path
    end

    def parse
      # read and parse xml file
      read_xml_rile
      parse_xml_data

      case @file_name
      when /\Asrml-\d{1}-\d{1,4}-squads.xml\z/
        Rails.logger.info "--- squad file detected ---#{@file_name}"
        parse_squad
        # call squads file parser
      when /\Asrml-\d{1}-\d{1,4}-results.xml\z/
        Rails.logger.info "--- results file detected ---#{@file_name}"
        parse_result
        # call result file parser
      when /\Asrml-\d{1}-\d{1,4}-f\d{1,8}-matchresults.xml\z/
        Rails.logger.info "--- matchresults file detected ---#{@file_name}"
        parse_match_result
      else
        msg = "created file is not matching our expected name: #{@file_name}"
        Rails.logger.info msg
      end
    end

    private

    def parse_squad
      retries ||= 0
      squad = OptaParser::SquadsFileParser.new(@xml_node)
      OptaParser::SquadMapper.new(squad).save
    rescue => e
      show_error(e, retries)
      retry if (retries += 1) < RETRY_TIMES
    end

    def parse_result
      retries ||= 0
      result = OptaParser::ResultFileParser.new(@xml_node)
      OptaParser::ResultMapper.new(result).save
    rescue => e
      show_error(e, retries)
      retry if (retries += 1) < RETRY_TIMES
    end

    def parse_match_result
      retries ||= 0
      match_result = OptaParser::MatchResultFileParser.new(@xml_node)
      OptaParser::MatchResultMapper.new(match_result).save
    rescue => e
      show_error(e, retries)
      retry if (retries += 1) < RETRY_TIMES
    end

    def read_xml_rile
      if File.file?(@file_path)
        @xml_data = File.open(@file_path, 'rb', &:read)
      else
        Rails.logger.info "---- file #{@file_path} does not exist"
      end
    end

    def parse_xml_data
      @xml_node = Ox.parse(@xml_data)
    end

    def show_error(e, retries)
      Rails.logger.error "#{'>' * 10} #{'-' * 10} #{retries} times tries fails"
      Rails.logger.error "#{'>' * 10} #{'-' * 10} error is #{e}"
      Rails.logger.error "backtrace is #{e.backtrace.join('\n')}"
      read_xml_rile
      parse_xml_data
    end
  end
end
