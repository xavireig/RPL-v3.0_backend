# frozen_string_literal: true

require 'ox'
require_relative './opta_parser/custom_logger'
require_relative './opta_parser/parse_helpers'
require_relative './opta_parser/competition_parser'
require_relative './opta_parser/match_parser'
require_relative './opta_parser/player_parser'
require_relative './opta_parser/team_parser'
require_relative './opta_parser/squads_file_parser'
require_relative './opta_parser/result_file_parser'
require_relative './opta_parser/match_official_parser'
require_relative './opta_parser/team_data_parser'
require_relative './opta_parser/match_result_file_parser'
require_relative './opta_parser/xml_parser'
require_relative './opta_parser/squad_mapper'
require_relative './opta_parser/result_mapper'
require_relative './opta_parser/match_result_mapper'

# top module
module OptaParser
end
