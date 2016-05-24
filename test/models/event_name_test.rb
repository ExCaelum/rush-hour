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
    aggregate_setup

    assert_equal 9, @event_name_most.payload_requests.count
    assert_equal 3, @event_name_least.payload_requests.count

    assert_equal "event_least", PayloadRequest.first.event_name.name
  end

  def test_it_sorts_by_requested
    aggregate_setup

    expected = ["event_most", "event_least"]

    assert_equal expected, EventName.most_to_least_received
  end

end
