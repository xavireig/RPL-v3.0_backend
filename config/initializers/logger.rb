MultiLogger.add_logger('rpl_drafting')
MultiLogger.add_logger('opta_parser')
MultiLogger.add_logger('subscription')

# set logger level
Rails.logger.rpl_drafting.level = :error
Rails.logger.opta_parser.level = :error
