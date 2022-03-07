namespace :data do
  desc 'Update the footballers ranks from CSV'
  task :update_footballers_ranks, [:csv_file] => [:environment] do |t, args|
    require 'csv'
    require 'pp'

    csv_text = File.read(args[:csv_file])
    csv = CSV.parse(csv_text, :headers => true)
    footballer_ranks = {}
    csv.each do |row|
      values = row.to_hash
      if(values.length == 2 && values['id'] != nil && values['rank'] != nil )
        footballer_ranks[values['id'].to_i] = values['rank'].to_i
      end
    end
    current_season = Season.current_season
    Footballer.all.each do |f|
      if(footballer_ranks[f.id])
        puts "#{f.id}: set to rank: #{footballer_ranks[f.id]}"
        f.update_attribute(:rank, footballer_ranks[f.id])
      else
        puts "#{f.id}: set to rank: 2048"
        f.update_attribute(:rank, 2048)
      end
    end
  end
end
