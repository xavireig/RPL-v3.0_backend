# frozen_string_literal: true

require_relative '../../parser/observe_rpl_files'

namespace :observer do
  task start: :environment do
    log_path = Rails.root.join('log', 'rpl_file_observer.log')
    Rails.logger       = Logger.new(log_path)

    # set default log level
    Rails.logger.level = Logger.const_get((ENV['LOG_LEVEL'] || 'info').upcase)

    # make process daemon on production
    # set BACKGROUND env variable
    Process.daemon(true, true)

    # store current process id that will be need to remove
    # daemonize process
    pid_file_path = Rails.root.join('tmp', 'pids', 'rpl_file_observer.pid')
    File.open(pid_file_path, 'w') { |f| f << Process.pid }

    Signal.trap('TERM') { abort }

    Rails.logger.info 'Start daemon...'

    loop do
      # Daemon code goes here...
      ObserveRplFiles.observe
      sleep ENV['INTERVAL'] || 1
    end
  end
end
