# frozen_string_literal: true

require 'rake'

# example s_file_path '/home/sumon/projects_doc/RPL/final/1/*.xml'
# example d_folder_path 'rpl@staging.rotopremierleague.com:/home/rpl'
desc 'manually upload opta file from local computer to server computer'
task :upload_file, %i[s_folder_path d_folder_path] do |_t, args|
  s_path = args[:s_folder_path]
  d_path = args[:d_folder_path]
  run_command(s_path, d_path) unless s_path.nil? || d_path.nil?
end

def run_command(s_path, d_path)
  puts "---- passing s_folder_path #{s_path}, d_folder_path #{d_path}"
  count = 0
  wait_time = 2

  Dir.glob(s_path) do |file|
    count += 1
    command =
      "scp #{file} #{d_path}"
    system(command)
    puts "---command #{command}"
    sleep wait_time
  end

  puts '***************** file upload complete ****************'
  puts "************ total file uploaded #{count} *************"
end
