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
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    url = Url.create(address: "www.turing.com")

    assert_equal 1, url.payload_requests.count
    assert_equal 1, url.payload_requests.first.event_name_id
    assert_equal 48, url.payload_requests.first.responded_in
    assert_equal "www.turing.com", pr.url.address
  end

  def test_it_sorts_by_requested
    pr1 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 1)
    pr2 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 1)
    pr3 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 2)
    pr4 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 3)
    pr5 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 3)

    url1 = Url.create(address: "www.url1.com")
    url2 = Url.create(address: "www.url2.com")
    url3 = Url.create(address: "www.url3.com")

    assert_equal ["www.url1.com", "www.url3.com", "www.url2.com"], Url.most_to_least_requested

    pr6 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 3)
    pr7 = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",responded_in: 48,  referred_by: "www.referrer.com", request_type_id: 1, parameters: "[]",event_name_id: 1, user_agent: "browswer and OS", resolution_id: 1, ip: "100.00.00.00", url_id: 3)

    assert_equal ["www.url3.com", "www.url1.com", "www.url2.com"], Url.most_to_least_requested


  end

end
