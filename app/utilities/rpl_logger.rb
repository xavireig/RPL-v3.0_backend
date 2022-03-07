# frozen_string_literal: true

module RplLogger
  class << self
    def drafting_log(league_id, msg)
      logger_name = "rpl_drafting_#{league_id}"
      file_name =
        "*** now we are in #{caller[0][/`.*'/][1..-2]}"
      location = "that is at #{caller_locations.first}"

      make_sure_logger_exists(logger_name)
      Rails.logger.send(logger_name.to_sym).error "#{file_name} #{location}"
      Rails.logger.send(logger_name.to_sym).error "message: #{msg}"
    end

    def make_sure_logger_exists(lm)
      unless Rails.logger.respond_to?(lm.to_sym)
        MultiLogger.add_logger(lm)
        Rails.logger.send(lm.to_sym).level = :error
      end
    end
  end
end
