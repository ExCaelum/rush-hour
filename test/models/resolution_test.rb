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
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    resolution = Resolution.create(height: "1000", width: "100")

    assert_equal 1, resolution.payload_requests.count
    assert_equal 1, resolution.payload_requests.first.resolution_id
    assert_equal 48, resolution.payload_requests.first.responded_in
    assert_equal "1000", pr.resolution.height
  end

  def test_resolution_list
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)


    Resolution.create(height: "1", width: "1")

    assert_equal ["1 x 1"], Resolution.list_of_resolutions

    Resolution.create(height: "2", width: "2")

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 2,
    ip: "100.00.00.00",
    url_id: 1)

    assert_equal ["1 x 1", "2 x 2"], Resolution.list_of_resolutions

  end
end
