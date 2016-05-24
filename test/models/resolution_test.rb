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
    aggregate_setup
    pr = PayloadRequest.first

    assert_equal 6, @resolution_most.payload_requests.count
    assert_equal 6, @resolution_least.payload_requests.count
    assert_equal 1, @resolution_most.payload_requests.first.resolution_id
    assert_equal 30, @resolution_most.payload_requests.first.responded_in
    assert_equal "1080", pr.resolution.height
  end

  def test_resolution_list
    aggregate_setup

    assert_equal ["1080 x 1920" , "1200 x 1600" ], Resolution.list_of_resolutions.sort
  end
end
