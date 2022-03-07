# frozen_string_literal: true

# Organization
# ============
#
# - Keep this list alphabetized.
# - All version constraints must have a documented reason, and a condition
#   under which the constraint can be removed. Constraints which lack this
#   documentation will be lifted without warning.
#
# Gems which should not be installed
# ==================================
#
# 1. therubyracer
#   - deprecated on systems that have node
# > required and strongly discouraged as [it] uses a very large
# > amount of memory.
# > https://devcenter.heroku.com/articles/rails-asset-pipeline
#

source 'https://rubygems.org'

ruby '2.4.10'

gem 'acts_as_list'

gem 'tzinfo-data'

gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'exception_notification'

gem 'braintree'

gem 'devise'

gem 'dragonfly'

# used to create test data in staging.
gem 'faker'

gem 'kaminari'

gem 'multi_logger'

gem 'ox'

gem 'pg'

gem 'puma'

gem 'rack-cors'

# This constraint drastically speeds up bundler's dependency resolution
gem 'rails', '~> 5.1.4'

gem 'rails_admin'

gem 'rails_admin_rollincode'

gem 'listen'

gem 'redis', "~> 3.0"

gem 'trailblazer'

gem 'trailblazer-rails'

gem 'tzinfo'

gem 'sidekiq'

gem 'slack-notifier'

gem 'multi_json'

gem 'whenever', require: false

gem 'rollbar'

gem 'pry-nav'
gem 'pry-rails'
gem 'pry-remote'

gem 'bcrypt-ruby', '3.1.0', :require => 'bcrypt'

group :development, :test do
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'letter_opener'
  gem 'rubocop'
end

group :development do
  gem 'benchmark-ips'
  gem 'bullet'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'sunzi', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
