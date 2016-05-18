require_relative '../test_helper'

class ResolutionTest < Minitest::Test
  include TestHelpers

  def test_it_creates_a_resolution
    resolution = Resolution.create(height: "1000", width: "100")

    assert_equal "1000", resolution.height
    assert_equal "100", resolution.width

  end

  def test_it_invalidates_resolution
    resolution = Resolution.create(height: "1000")

    assert_equal true, resolution.invalid?
    assert_equal 1, resolution.errors.messages.length
  end

  def test_resolution_payload_requests_relationship
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent: "browswer and OS",
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    resolution = Resolution.create(height: "1000", width: "100")

    assert_equal 1, resolution.payload_requests.count
    assert_equal 1, resolution.payload_requests.first.resolution_id
    assert_equal 48, resolution.payload_requests.first.responded_in
    assert_equal "1000", pr.resolution.height
  end
end
