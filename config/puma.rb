# frozen_string_literal: true

# Number of processes per dyno
#workers Integer(ENV['WEB_CONCURRENCY'] || 2)

# Number of threads per worker (`1,1` means min of 1, max of 1)
thread_count = ENV.fetch('PUMA_THREAD_COUNT', 3)
threads thread_count, thread_count

preload_app!

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
