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

  def test_event_payload_connection
    event_name = EventName.create

    assert event_name.respond_to?(:payload_requests)
  end

  def test_event_name_payload_requests_relationship
    associations = standard_payload_with_associations

    assert_equal 1, associations[:event].payload_requests.count

  end

  def test_it_sorts_by_requested
    associations = standard_payload_with_associations
    event_least = EventName.create(name: "LeastEvent")

    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name: associations[:event],
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 1,
                      key: "SHA2")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name: event_least,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 1,
                      key: "SHA2")

    expected = ["MostEvent", "LeastEvent"]

    assert_equal expected, EventName.most_to_least_received
  end

end
