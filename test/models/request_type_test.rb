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
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent_id: 1,
                          resolution_width: "1000",
                          resolution_height:"1000",
                          ip: "100.00.00.00",
                          url_id: 1)
    rt = RequestType.create(verb: "POST")

    assert_equal 1, rt.payload_requests.count
    assert_equal 48, rt.payload_requests.first.responded_in
    assert_equal "POST", pr.request_type.verb
  end

end
