require_relative '../test_helper'

class EventNameTest < Minitest::Test
  include TestHelpers

  def test_it_creates_an_event_name
    event_name = EventName.create(name: "event")

    assert_equal "event", event_name.name
  end

  def test_it_invalidates_event_name
    event_name = EventName.create

    assert_equal true, event_name.invalid?
    assert_equal 1, event_name.errors.messages.length
  end

  def test_event_name_payload_requests_relationship
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 48,
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               resolution_id: 1,
                               user_agent_id: 1,
                               ip_id: 1,
                               url_id: 1,
                               client_id: 1,
                               key: "SHA-1")

    event_name = EventName.create(name: "event")

    assert_equal 1, event_name.payload_requests.count
    assert_equal 1, event_name.payload_requests.first.event_name_id
    assert_equal "event", pr.event_name.name
  end

  def test_it_sorts_by_requested
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
                          key: "SHA-1")
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
                          key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 2,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 2,
                          client_id: 1,
                          key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 3,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1,
                          key: "SHA-1")
    PayloadRequest.create(requested_at: "2014-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1,
                          key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 3,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          client_id: 1,
                          key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 3,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1,
                          key: "SHA-1")

    EventName.create(name: "event1")
    EventName.create(name: "event2")
    EventName.create(name: "event3")

    assert_equal ["event1", "event3", "event2"], EventName.most_to_least_received

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 3,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1,
                          key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 3,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1,
                          key: "SHA-1")

    assert_equal ["event3", "event1", "event2"], EventName.most_to_least_received
  end

end
