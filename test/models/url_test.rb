require_relative '../test_helper'

class UrlTest < Minitest::Test
  include TestHelpers

  def test_it_creates_a_url
    url = Url.create(address: "www.turing.com")

    assert_equal "www.turing.com", url.address
  end

  def test_it_invalidates_url
    url = Url.create

    assert_equal true, url.invalid?
    assert_equal 1, url.errors.messages.length
  end

  def test_url_payload_requests_relationship
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 48,
                               referrer_id: 1,
                               request_type: "GET",
                               parameters: "[]",
                               event_name: "event",
                               user_agent: "browswer and OS",
                               resolution_width: "1000",
                               resolution_height:"1000",
                               ip_id: 1,
                               url_id: 1)
    url = Url.create(address: "www.turing.com")

    assert_equal 1, url.payload_requests.count
    assert_equal "event", url.payload_requests.first.event_name
    assert_equal "www.turing.com", pr.url.address
  end

  def test_it_can_find_calculate_response_time_stats
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 100,
                               referrer_id: 1,
                               request_type: "GET",
                               parameters: "[]",
                               event_name: "event",
                               user_agent: "browswer and OS",
                               resolution_width: "1000",
                               resolution_height:"1000",
                               ip_id: 1,
                               url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 20,
                               referrer_id: 1,
                               request_type: "GET",
                               parameters: "[]",
                               event_name: "event",
                               user_agent: "browswer and OS",
                               resolution_width: "1000",
                               resolution_height:"1000",
                               ip_id: 1,
                               url_id: 1)
    assert_equal 2, PayloadRequest.count
    Url.create(address: "www.turing.com")
    assert_equal 100, Url.max_response
    assert_equal 20, Url.min_response
    assert_equal 60, Url.average_response
  end

end
