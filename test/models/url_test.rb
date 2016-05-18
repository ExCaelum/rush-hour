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
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               resolution_id: 1,
                               user_agent_id: 1,
                               ip_id: 1,
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
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 2)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 3)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 3)

    Url.create(address: "www.url1.com")
    Url.create(address: "www.url2.com")
    Url.create(address: "www.url3.com")

    assert_equal ["www.url1.com", "www.url3.com", "www.url2.com"], Url.most_to_least_requested

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 3)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 3)

    assert_equal ["www.url3.com", "www.url1.com", "www.url2.com"], Url.most_to_least_requested

  end


  def test_response_time_list_includes_all_when_only_one_url
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    url= Url.create(address: "www.url1.com")

    assert_equal [48, 40], url.list_response_times

  end


  def test_response_time_list_includes_all_when_multiple_urls
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 2)

    url= Url.create(address: "www.url1.com")

    assert_equal [48], url.list_response_times

  end


  def test_response_time_list_includes_duplicates
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    url= Url.create(address: "www.url1.com")

    assert_equal [48, 48], url.list_response_times

  end



  def test_returns_top_referrers_for_url_less_than_3
    #can remove skip once referrer migration happens
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 2,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 2,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 2,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 2,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    url=Url.create(address: "www.url1.com")


    Referrer.create(address: "referrer1")
    Referrer.create(address: "referrer2")

    assert_equal ["referrer2", "referrer1"], url.top_three_referrers

  end

  def test_returns_top_referrers_for_url_more_than_3
    #can remove skip once referrer migration happens
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 48,
    referrer_id: 1,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 1,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 2,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 2,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 3,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 3,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
    responded_in: 40,
    referrer_id: 4,
    request_type_id: 1,
    parameters: "[]",
    event_name_id: 4,
    user_agent_id: 1,
    resolution_id: 1,
    ip_id: 1,
    url_id: 1)

    url = Url.create(address: "www.url1.com")


    Referrer.create(address: "referrer1")
    Referrer.create(address: "referrer2")
    Referrer.create(address: "referrer3")
    Referrer.create(address: "referrer4")

    assert_equal ["referrer1", "referrer2", "referrer3"], url.top_three_referrers

  end

  def test_url_has_verb_association
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 40,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 4,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)

    url = Url.create(address: "www.turing.com")
    RequestType.create(verb: "GET")

    assert_equal ["GET"], url.http_verbs
  end

  def test_url_has_verb_association_without_duplicates
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 40,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 4,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 40,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 4,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)

    url = Url.create(address: "www.turing.com")
    RequestType.create(verb: "GET")

    assert_equal ["GET"], url.http_verbs
  end

  def test_url_can_find_one_popular_agent
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 40,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 4,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)
    UserAgent.create(os: "Windows", browser: "Chrome")
    url = Url.create(address: "www.turing.com")


    assert_equal ["Windows Chrome"], url.popular_agents
  end

  def test_url_can_find_popular_agents
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 40,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 4,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 40,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 4,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 40,
                            referrer_id: 1,
                            request_type_id: 1,
                            parameters: "[]",
                            event_name_id: 4,
                            user_agent_id: 1,
                            resolution_id: 1,
                            ip_id: 1,
                            url_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 40,
                            referrer_id: 1,
                            request_type_id: 1,
                            parameters: "[]",
                            event_name_id: 4,
                            user_agent_id: 2,
                            resolution_id: 1,
                            ip_id: 1,
                            url_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 40,
                            referrer_id: 1,
                            request_type_id: 1,
                            parameters: "[]",
                            event_name_id: 4,
                            user_agent_id: 2,
                            resolution_id: 1,
                            ip_id: 1,
                            url_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 40,
                            referrer_id: 1,
                            request_type_id: 1,
                            parameters: "[]",
                            event_name_id: 4,
                            user_agent_id: 3,
                            resolution_id: 1,
                            ip_id: 1,
                            url_id: 1)

    UserAgent.create(os: "Windows", browser: "Chrome")
    UserAgent.create(os: "Macintosh", browser: "Safari")
    UserAgent.create(os: "Linux", browser: "Internet Explorer")
    UserAgent.create(os: "Macintosh", browser: "Firefox")



    url = Url.create(address: "www.turing.com")


    assert_equal ["Windows Chrome", "Macintosh Safari", "Linux Internet Explorer"], url.popular_agents
  end

  def test_it_can_find_calculate_response_time_stats
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 100,
                               referrer_id: 1,
                               request_type_id: 1, 
                               parameters: "[]",
                               event_name_id: 1,
                               user_agent_id: 1, 
                               resolution_id: 1,
                               ip_id: 1,
                               url_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 20,
                               referrer_id: 1,
                               request_type_id: 1, 
                               parameters: "[]",
                               event_name_id: 1,
                               user_agent_id: 1, 
                               resolution_id: 1,
                               ip_id: 1,
                               url_id: 1)

    assert_equal 2, PayloadRequest.count
    Url.create(address: "www.turing.com")
    assert_equal 100, Url.max_response
    assert_equal 20, Url.min_response
    assert_equal 60, Url.average_response
  end

end
