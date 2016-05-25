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

  def test_resolution_payload_connection
    resolution = Resolution.create

    assert resolution.respond_to?(:payload_requests)
  end

  def test_resolution_payload_requests_relationship
    associations = standard_payload_with_associations
    pr = PayloadRequest.first

    assert_equal 1, associations[:resolution].payload_requests.count

  end

  def test_resolution_list
    standard_payload_with_associations
    standard_payload_with_associations
    other_resolution = Resolution.create(width: 2, height: 2)
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution: other_resolution,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 100,
                      key: "SHA2")

    assert_equal ["1 x 1" , "2 x 2" ], Resolution.list_of_resolutions.sort
  end
end
