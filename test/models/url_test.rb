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
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    url = Url.create(address: "www.turing.com")

    assert_equal 1, url.payload_requests.count
    assert_equal 1, url.payload_requests.first.event_name_id
    assert_equal 48, url.payload_requests.first.responded_in
    assert_equal "www.turing.com", pr.url.address
  end

  def test_it_sorts_by_requested
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
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 2)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 3)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 3)

    Url.create(address: "www.url1.com")
    Url.create(address: "www.url2.com")
    Url.create(address: "www.url3.com")

    assert_equal ["www.url1.com", "www.url3.com", "www.url2.com"], Url.most_to_least_requested

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 3)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 3)

    assert_equal ["www.url3.com", "www.url1.com", "www.url2.com"], Url.most_to_least_requested

  end


  def test_response_time_list_includes_all_when_only_one_url
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
    responded_in: 40,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    url= Url.create(address: "www.url1.com")

    assert_equal [48, 40], url.list_response_times

  end


  def test_response_time_list_includes_all_when_multiple_urls
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
    responded_in: 40,
    referred_by: "www.referrer.com",
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 2)

    url= Url.create(address: "www.url1.com")

    assert_equal [48], url.list_response_times

  end


  def test_response_time_list_includes_duplicates
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

    url= Url.create(address: "www.url1.com")

    assert_equal [48, 48], url.list_response_times

  end



  def test_returns_top_referrers_for_url_less_than_3
    skip
    #can remove skip once referrer migration happens
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 2,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 2,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 2,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 2,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    url=Url.create(address: "www.url1.com")


    Referrer.create(name: "referrer1")
    Referrer.create(name: "referrer2")

    assert_equal ["referrer2", "referrer1"], url.top_three_referrers

  end



  def test_returns_top_referrers_for_url_more_than_3
    skip
    #can remove skip once referrer migration happens
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    rreferrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 2,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 2,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 3,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 3,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 4,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 4,
    user_agent_id: 1,
    resolution_id: 1,
    ip: "100.00.00.00",
    url_id: 1)

    url = Url.create(address: "www.url1.com")


    Referrer.create(name: "referrer1")
    Referrer.create(name: "referrer2")
    Referrer.create(name: "referrer3")
    Referrer.create(name: "referrer4")

    assert_equal ["referrer1", "referrer2", "referrer3"], url.top_three_referrers

  end





end
