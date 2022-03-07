# frozen_string_literal: true

# TODO: I am not sure this is best idea for loading
# lib/ code
require_relative '../../lib/parser/opta_parser'

# sidekiq worker
class ParseXmlWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, backtrace: true, queue: :file_queue

  def perform(file_name, file_path)
    if /\Asrml-.+xml\z/.match?(file_name)
      file_path = "#{file_path}/#{file_name}"
      Rails.logger.info "File added: #{file_name}, path #{file_path}"
      ::OptaParser::XmlParser.new(file_path, file_name).parse
      create_xml_file(file_path, file_name)
    else
      Rails.logger.info " added file is not expected one: #{file_name}"
    end
  end

  private

  def create_xml_file(file_path, name)
    file_data = File.read(file_path)
    file = XmlFile.create!(file: file_data, file_name: name)
  rescue => e
    msg = "Creating xmlFile fails because #{e}"
    OptaParser.prnt_e_log(msg)
  ensure
    # ensure always return file obj
    file
  end
end
