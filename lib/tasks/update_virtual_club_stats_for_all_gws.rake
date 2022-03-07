# frozen_string_literal: true

# # small class to display progress of rake task
# class ProgressBar
#
#   def initialize(total)
#     @total   = total
#     @counter = 1
#   end
#
#   def increment
#     complete = sprintf("%#.2f%", ((@counter.to_f / @total.to_f) * 100))
#     print "\r\e[0K#{@counter}/#{@total} (#{complete})"
#     @counter += 1
#   end
#
# end

desc 'update virtual club league standing by calculating all game week stats'
task update_virtual_club_stats_for_all_gws: :environment do
  # make process daemon on production
  # set BACKGROUND env variable
  Process.daemon(true, true)

  # store current process id that will be need to remove
  # daemonize process
  pid_file_path = Rails.root.join('tmp', 'pids', 'update_virtual_club_stats.pid')
  File.open(pid_file_path, 'w') { |f| f << Process.pid }

  Signal.trap('TERM') { abort }

  leagues = League.includes(:virtual_clubs).where(draft_status: 'completed')

  # progress_bar = ProgressBar.new(leagues.count)
  leagues.each do |l|
    l.virtual_clubs.each do |vc|
      next if vc.current_game_week.nil?
      standing = vc.standing
      place = vc.place
      vc.update_attributes(
        total_pts: standing[:points],
        total_win: standing[:win],
        total_loss: standing[:lost],
        total_draw: standing[:draw],
        total_score: standing[:score],
        form: standing[:form],
        rank: place
      )
    end
    # progress_bar.increment
  end
end
