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
  attr_reader :client
  def setup
    DatabaseCleaner.start
    super
  end
  def teardown
    DatabaseCleaner.clean
    super
  end

  # def standard_payload_with_associations
  #   client = Client.create(identifier: "Client", root_url: "www.client.com")
  #   event = EventName.create(name: "Event")
  #   referrer = Referrer.create(address: "www.referrer.com")
  #   request_type = RequestType.create(verb: "GET")
  #   resolution = Resolution.create(width: 1, height: 1)
  #   url = Url.create(address: "www.client.com/url")
  #   user_agent = UserAgent.create(os: "OS", browser: "Browser")
  #   payload_request = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
  #   responded_in: 10,
  #   parameters: "[]",
  #   url_id: url.id,
  #   event_name_id: event.id,
  #   request_type_id: request_type.id,
  #   resolution_id: resolution.id,
  #   referrer_id: referrer.id,
  #   user_agent_id: user_agent.id,
  #   ip_id: 1,
  #   client_id: client.id,
  #   key: "SHA")
  #   {client: client, event: event, referrer: referrer, request_type: request_type, resolution: resolution, url: url, user_agent: user_agent, payload_request: payload_request}
  # end

  def aggregate_setup
    @client = Client.create(identifier: "jumpstartlab", root_url: "http://jumpstartlab.com")

    @url_least = Url.find_or_create_by({address: "www.least.com"})
    @url_most = Url.find_or_create_by({address: "www.most.com"})

    @referrer1 = Referrer.find_or_create_by({address: "www.@referrer1.com"})
    referrer2 = Referrer.find_or_create_by({address: "www.referrer2.com"})

    @request_type_most = RequestType.find_or_create_by({verb: "GET"})
    request_type_post = RequestType.find_or_create_by({verb: "POST"})
    request_type_patch = RequestType.find_or_create_by({verb: "PATCH"})

    @event_name_most  = EventName.find_or_create_by({name: "event_most"})
    @event_name_least = EventName.find_or_create_by({name: "event_least"})

    @user_agent1 = UserAgent.find_or_create_by({os: "OSX", browser: "Chrome"})
    user_agent2 = UserAgent.find_or_create_by({os: "OSX", browser: "Safari"})
    user_agent3 = UserAgent.find_or_create_by({os: "Windows", browser: "Chrome"})
    user_agent4 = UserAgent.find_or_create_by({os: "Linux", browser: "Chrome"})
    user_agent5 = UserAgent.find_or_create_by({os: "Windows", browser: "IE"})

    @resolution_most = Resolution.find_or_create_by({width: "1920", height: "1080"})
    @resolution_least = Resolution.find_or_create_by({width: "1600", height: "1200"})

    ip = Ip.find_or_create_by(address: "100.00.00.00")

    response_time1 = 30
    response_time2 = 45
    response_time3 = 40
    response_time4 = 55

    @avg_response_time = ((response_time1 + response_time2 + response_time3 + response_time4) / 4.0).round(2)
    @max_response_time = response_time4
    @min_response_time = response_time1

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 20:38:28 -0700",
    responded_in: response_time1,
    referrer: @referrer1,
    request_type: @request_type_most,
    parameters: "[]",
    event_name: @event_name_least,
    user_agent: @user_agent1,
    resolution: @resolution_most,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_least ,
    requested_at: "2013-02-16 20:38:28 -0700",
    responded_in: response_time2,
    referrer: referrer2,
    request_type: @request_type_most,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: user_agent2,
    resolution: @resolution_most,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time3,
    referrer: @referrer1,
    request_type: @request_type_most,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: user_agent3,
    resolution: @resolution_least,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time4,
    referrer: referrer2,
    request_type: request_type_patch,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: user_agent4,
    resolution: @resolution_least,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time1,
    referrer: @referrer1,
    request_type: request_type_post,
    parameters: "[]",
    event_name: @event_name_least,
    user_agent: user_agent5,
    resolution: @resolution_most,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_least ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time2,
    referrer: referrer2,
    request_type: request_type_post,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: @user_agent1,
    resolution: @resolution_most,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time3,
    referrer: @referrer1,
    request_type: @request_type_most,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: user_agent2,
    resolution: @resolution_least,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time4,
    referrer: referrer2,
    request_type: request_type_patch,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: user_agent3,
    resolution: @resolution_least,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time1,
    referrer: @referrer1,
    request_type: request_type_post,
    parameters: "[]",
    event_name: @event_name_least,
    user_agent: user_agent4,
    resolution: @resolution_most,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time2,
    referrer: referrer2,
    request_type: @request_type_most,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: user_agent5,
    resolution: @resolution_least,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time3,
    referrer: @referrer1,
    request_type: @request_type_most,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: @user_agent1,
    resolution: @resolution_most,
    client: client,
    ip: ip,
    key: "SHA1")

    PayloadRequest.create(url: @url_most ,
    requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: response_time4,
    referrer: referrer2,
    request_type: request_type_patch,
    parameters: "[]",
    event_name: @event_name_most,
    user_agent: @user_agent1,
    resolution: @resolution_least,
    client: client,
    ip: ip,
    key: "SHA1")
  end

end

Capybara.app = RushHour::Server

class FeatureTest < Minitest::Test
  include Capybara::DSL
  include TestHelpers
end
