require_relative '../test_helper'

class SeeEventIndexTest < Minitest::Test
  include Rack::Test::Methods
  include TestHelpers

  def app
    RushHour::Server
  end

  def test_it_hits_event_index
    Client.create(identifier: "Client1", root_url: "www.client.com")
    EventName.create(name: "Event1")
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
                               client_id: 1)
    get '/sources/Client1/events'
    assert_equal 200, last_response.status
    assert_equal "event listing for Client1", last_response.body
  end

end
