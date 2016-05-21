ENV["RACK_ENV"] ||= "test"

require 'simplecov'
SimpleCov.start
require 'bundler'
Bundler.require

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'minitest/pride'
require 'capybara/dsl'
require 'database_cleaner'
require 'tilt/erb'


Capybara.app = RushHour::Server
DatabaseCleaner.strategy = :truncation

module TestHelpers
  def setup
    DatabaseCleaner.start
    super
  end
  def teardown
    DatabaseCleaner.clean
    super
  end
end

Capybara.app = RushHour::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
