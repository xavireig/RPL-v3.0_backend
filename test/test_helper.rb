# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/spec'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

module Minitest
  class Spec
    include FactoryBot::Syntax::Methods

    before :each do
      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end
  end
end

module ActiveSupport
  class TestCase
  end
end
