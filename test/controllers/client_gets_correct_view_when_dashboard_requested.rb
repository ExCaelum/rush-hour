require_relative '../test_helper'

class GetCorrectClientDashboardTest < Minitest::Test
  include Rack::Test::Methods
  include TestHelpers

  def app
    RushHour::Server
  end

  def test_gets_correct_route_when_client_and_payload_reqs_exist
    Client.create(identifier: "Client2", root_url: "www.client2.com")
    RequestType.create(verb: "GET")
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
    get '/sources/Client2'
    assert_equal 200, last_response.status
    expected = "Welcome to the homepage of Client2"
    assert_equal true, last_response.body.include?(expected)
    assert_equal true, last_response.body.include?("GET")
    assert_equal true, last_response.body.include?("48")

  end

  def test_gets_correct_route_when_client_exists_without_payload
    Client.create(identifier: "Client2", root_url: "www.client2.com")
    get '/sources/Client2'
    assert_equal 200, last_response.status
    expected = "There is no payload data"
    assert_equal true, last_response.body.include?(expected)
  end

  def test_gets_correct_route_when_dashboard_request_for_invalid_client
    get '/sources/Client3'
    assert_equal 200, last_response.status
    expected = "Client3 does not exist"
    assert_equal true, last_response.body.include?(expected)
  end

end
