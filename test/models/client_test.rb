require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_connections
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)
    c1 = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    Client.create(identifier: "KingSoopers", root_url: "www.KingSoopers.com")
    url = Url.create(address: "www.BestBuy.com/cameras")

    assert_equal 2, c1.payload_requests.length
    assert_equal "www.BestBuy.com/cameras", c1.urls.first.address
    assert_equal "www.BestBuy.com", url.clients.first.root_url
  end


  def test_it_groups_events_by_hour_for_client
  PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                        responded_in: 48,
                        referrer_id: 1,
                        request_type_id: 1,
                        parameters: "[]",
                        event_name_id: 1,
                        resolution_id: 1,
                        user_agent_id: 1,
                        ip_id: 1,
                        url_id: 1,
                        client_id: 1)
  PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                        responded_in: 48,
                        referrer_id: 1,
                        request_type_id: 1,
                        parameters: "[]",
                        event_name_id: 1,
                        resolution_id: 1,
                        user_agent_id: 1,
                        ip_id: 1,
                        url_id: 1,
                        client_id: 1)
  PayloadRequest.create(requested_at: "2013-02-16 20:38:28 -0700",
                        responded_in: 48,
                        referrer_id: 1,
                        request_type_id: 1,
                        parameters: "[]",
                        event_name_id: 1,
                        resolution_id: 1,
                        user_agent_id: 1,
                        ip_id: 1,
                        url_id: 1,
                        client_id: 1)
  client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
  event = EventName.create(name: "event1")

  expected = {21.0 =>2, 20.0 =>1}
  assert_equal expected, client.event_requests_by_hour("event1")
end

def test_groups_events_by_hour_returns_empty_if_no_requests

  client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
  event = EventName.create(name: "event1")

  assert_equal ({}), client.event_requests_by_hour("event1")
end



end
