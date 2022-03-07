# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require "tzinfo"

def local(time)
  TZInfo::Timezone.get('Europe/London').local_to_utc(Time.parse(time))
end

every :thursday, at: local("3:00 pm"), roles: [:app] do
  runner "AwardTransferBonusWorker.perform_async"
end

every :tuesday, at: local("1:00 am"), roles: [:app] do
  runner "UpdateVirtualClubStats.perform_async"
  runner "UpdateVirtualFootballerPtsWorker.perform_async"
  runner "PrepareNextGwLineupsWorker.perform_async"
end

every :thursday, at: local("11:00 pm"), roles: [:app] do
  runner "UpdateVirtualScoresForAllGwsWorker.perform_async"
end
