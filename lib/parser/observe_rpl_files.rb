# frozen_string_literal: true

require_relative 'opta_parser'

# observe indicate folder, trigger event after
module ObserveRplFiles
  def self.observe
    directory = CONFIG['xml_folder']
    watcher = Listen.to(directory, only: /\.xml/) do |modified, added, removed|
      added.map do |file|
        time = Time.now + 3.seconds
        ParseXmlWorker.perform_at(time, File.basename(file), File.dirname(file))
      end
      modified.map do |file|
        time = Time.now + 3.seconds
        ParseXmlWorker.perform_at(time, File.basename(file), File.dirname(file))
      end
    end
    watcher.start # not blocking
    sleep
  end
end
