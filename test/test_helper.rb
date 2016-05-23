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

  def standard_payload_with_associations
    client = Client.create(identifier: "Client", root_url: "www.client.com")
    event = EventName.create(name: "Event")
    referrer = Referrer.create(address: "www.referrer.com")
    request_type = RequestType.create(verb: "GET")
    resolution = Resolution.create(width: 1, height: 1)
    url = Url.create(address: "www.client.com/url")
    user_agent = UserAgent.create(os: "OS", browser: "Browser")
    payload_request = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 10,
                      parameters: "[]",
                      url_id: url.id,
                      event_name_id: event.id,
                      request_type_id: request_type.id,
                      resolution_id: resolution.id,
                      referrer_id: referrer.id,
                      user_agent_id: user_agent.id,
                      ip_id: 1,
                      client_id: client.id,
                      key: "SHA")
    {client: client, event: event, referrer: referrer, request_type: request_type, resolution: resolution, url: url, user_agent: user_agent, payload_request: payload_request}
  end

end

Capybara.app = RushHour::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
