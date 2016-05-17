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
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent: "browswer and OS",
                          resolution_width: "1000",
                          resolution_height:"1000",
                          ip: "100.00.00.00",
                          url_id: 1)

    url = Url.create(address: "www.turing.com")

    assert_equal 1, url.payload_requests.count
    assert_equal 1, url.payload_requests.first.event_name_id
    assert_equal 48, url.payload_requests.first.responded_in
    assert_equal "www.turing.com", pr.url.address
  end
end
