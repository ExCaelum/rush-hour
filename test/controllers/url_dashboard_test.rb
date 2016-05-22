require_relative '../test_helper'

class GetCorrectUrlDashboardTest < Minitest::Test
  include Rack::Test::Methods
  include TestHelpers

  def app
    RushHour::Server
  end

  def test_gets_correct_route_when_url_reqs_exist
    Client.create(identifier: "Client2", root_url: "www.client2.com")
    Url.create(address: "www.client2.com/test")
    Referrer.create(address: "www.client2.com")
    RequestType.create(verb: "GET")
    Resolution.create(height: "1", width: '1')
    UserAgent.create(os: "OS", browser: "Browser")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 48,
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               user_agent_id: 1,
                               resolution_id: 1,
                               ip_id: 1,
                               url_id: 1,
                               client_id: 1,
                               key: 1)
    get '/sources/Client2/urls/test'
    assert_equal 200, last_response.status
    expected = "This page provides detailed traffic analytics"
    assert_equal true, last_response.body.include?(expected)
    expected = "www.client2.com/test"
    assert_equal true, last_response.body.include?(expected)
    assert_equal true, last_response.body.include?("48")

  end

  def test_gets_correct_route_when_url_reqs_do_not_exist
    Client.create(identifier: "Client2", root_url: "www.client2.com")
    Url.create(address: "www.client2.com/test")
    Url.create(address: "www.client2.com/test2")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 48,
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               user_agent_id: 1,
                               resolution_id: 1,
                               ip_id: 1,
                               url_id: 1,
                               client_id: 1,
                               key: 1)
    get '/sources/Client2/urls/test2'
    assert_equal 200, last_response.status
    expected = "No Data for test2 for Client2"
    assert_equal true, last_response.body.include?(expected)
  end


end
