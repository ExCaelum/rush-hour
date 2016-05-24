require_relative '../test_helper'

class RequestTypeTest < Minitest::Test
  include TestHelpers

  def test_it_creates_a_request_type
    rt = RequestType.create(verb: "GET")

    assert_equal "GET", rt.verb
  end

  def test_it_invalidates_request_type
    rt = RequestType.create

    assert_equal true, rt.invalid?
    assert_equal 1, rt.errors.messages.length
  end

  def test_request_type_payload_request_relationship
    aggregate_setup

    rt =  RequestType.first
    pr = PayloadRequest.first

    assert_equal 6, rt.payload_requests.count
    assert_equal 30, rt.payload_requests.first.responded_in
    assert_equal "GET", pr.request_type.verb
  end

  def test_we_can_see_most_frequest_verbs
    aggregate_setup

    assert_equal "GET", RequestType.most_frequent_request_type.verb
  end

  def test_we_can_see_all_http_verbs
    aggregate_setup

    assert_equal ["GET", "PATCH", "POST"], RequestType.all_http_verbs.sort
  end

end
