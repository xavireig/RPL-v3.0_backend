namespace :data do
  desc 'Mark ex-league footballers as left'
  task :mark_footballers_as_left, [:csv_file] => [:environment] do |t, args|
    require 'csv'
    require 'pp'

    csv_text = File.read(args[:csv_file])
    csv = CSV.parse(csv_text, :headers => true)
    left_footballers = []
    missing_footballers = []
    csv.each do |row|
      values = row.to_hash
      if values.length == 1 && values['Id'] != nil
        footballer = Footballer.where(id: values['Id']).first
        if footballer.present?
          footballer.update_attribute(:left, true)
          left_footballers << footballer.id
          puts "Footballer #{footballer.name} (#{footballer.id}) marked as left."
        else
          missing_footballers << values['Id']
        end
      end
    end

    #Remove virtual footballers from leagues that not yet drafted
    current_season = Season.current_season
    current_season.leagues.where(draft_status: "pending").each do |league|
      removed = league.virtual_footballers.where(footballer_id: left_footballers).destroy_all
      puts "Removed #{removed.count} virtual footballers from league #{league.id}"
    end

    unless missing_footballers.empty?
      puts "Couldn't find footballers with ids:"
      missing_footballers.each do |id|
        puts id
      end
    end
  end
end
