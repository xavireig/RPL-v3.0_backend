# frozen_string_literal: true

require 'capistrano/setup'
require 'capistrano/deploy'

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/console'
require 'capistrano/rails/migrations'
require 'capistrano/sidekiq'
require 'whenever/capistrano'
require 'rollbar/capistrano3'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }
Dir.glob('lib/tasks/*.rake').each { |r| import r }
