# frozen_string_literal: true

# custom method for logging
module OptaParser
  def self.prnt_e_log(msg)
    error_indicator = "#{'>' * 10} #{'-' * 10}"
    Rails.logger.error "#{error_indicator} #{msg}"
  end
end
