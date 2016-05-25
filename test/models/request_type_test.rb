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

  def test_request_type_payload_connection
    request_type = RequestType.create

    assert request_type.respond_to?(:payload_requests)
  end

  def test_request_type_payload_request_relationship
    standard_payload_with_associations

    rt =  RequestType.first
    pr = PayloadRequest.first

    assert_equal 1, rt.payload_requests.count
    assert_equal "MOST", pr.request_type.verb
  end

  def test_we_can_see_most_frequest_verbs
    standard_payload_with_associations
    standard_payload_with_associations
    least_request_type = RequestType.create(verb: "LEAST")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type: least_request_type,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 1,
                      key: "SHA2")


    assert_equal "MOST", RequestType.most_frequent_request_type.verb
  end

  def test_we_can_see_all_http_verbs
    standard_payload_with_associations
    standard_payload_with_associations
    least_request_type = RequestType.create(verb: "LEAST")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type: least_request_type,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 1,
                      key: "SHA2")

    assert_equal ["LEAST", "MOST"], RequestType.all_http_verbs.sort
  end

end
