require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_connections_to_other_tables
    standard_payload_with_associations

    assert_equal 1, client.payload_requests.count
    assert_equal "www.client.com/most", client.urls.first.address
    assert_equal "www.MostReferrer.com", client.referrers.first.address
    assert_equal "MOST", client.request_types.first.verb
    assert_equal "MostEvent", client.event_names.first.name
    assert_equal "MostOS", client.user_agents.first.os
    assert_equal "1", client.resolutions.first.width
    assert_equal "ip", client.ips.first.address

  end

  def test_other_table_connections_to_client
    associations = standard_payload_with_associations

    expected = "www.client.com"
    assert_equal expected, associations[:url].clients.first.root_url
    assert_equal expected, associations[:referrer].clients.first.root_url
    assert_equal expected, associations[:request_type].clients.first.root_url
    assert_equal expected, associations[:event].clients.first.root_url
    assert_equal expected, associations[:user_agent].clients.first.root_url
    assert_equal expected, associations[:resolution].clients.first.root_url

  end

  def test_it_excludes_data_for_other_client
    standard_payload_with_associations
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: client.id + 1,
                          key: "SHA-1")

    assert_equal 1, client.payload_requests.count

  end


  def test_it_calculates_average_response_time_for_client
    standard_payload_with_associations

    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    assert_equal 15, client.average_response_time_for_client

  end

  def test_it_calculates_min_response_time_for_client
    standard_payload_with_associations
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    assert_equal 10, client.min_response_time_for_client

  end

  def test_it_calculates_max_response_time_for_client
    standard_payload_with_associations
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    assert_equal 20, client.max_response_time_for_client

  end

  def test_it_ids_most_frequent_request_verb_for_client
    associations = standard_payload_with_associations
    request_type_least = RequestType.create(verb: "LEAST")
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type: associations[:request_type],
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type: request_type_least,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    assert_equal "MOST", client.most_frequent_request_type_for_client

  end

  def test_it_lists_all_request_verbs_for_client
    standard_payload_with_associations
    request_type_least = RequestType.create(verb: "LEAST")
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type: request_type_least,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    assert_equal ["LEAST", "MOST"], client.all_http_verbs_for_client.sort

  end

  def test_it_lists_all_resolutions_for_client
    standard_payload_with_associations
    resolution = Resolution.create(width: 2, height: 2)
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution: resolution,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    expected = ["1 x 1", "2 x 2"]
    assert_equal expected, client.all_screen_resolutions_for_client.sort

  end

  def test_it_provides_breakdown_of_all_browswers_for_client
    standard_payload_with_associations
    user_agent = UserAgent.create(os: "OtherOS", browser: "OtherBrowser")
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent: user_agent,
                      ip_id: 1,
                      key: "SHA2")

    expected = {"MostBrowser"=>1, "OtherBrowser"=>1}
    assert_equal expected, client.browser_breakdown_for_client

  end


  def test_it_provides_breakdown_of_all_operating_systems_for_client
    standard_payload_with_associations
    user_agent = UserAgent.create(os: "OtherOS", browser: "OtherBrowser")
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent: user_agent,
                      ip_id: 1,
                      key: "SHA2")

    expected = {"MostOS"=>1, "OtherOS"=>1}
    assert_equal expected, client.operating_system_breakdown_for_client

  end


  def test_it_lists_all_urls_by_requests_for_client
    associations = standard_payload_with_associations
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url: associations[:url],
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")

    url = Url.create(address: 'www.client.com/least')
    client.payload_requests.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url: url,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA3")


    expected = ["www.client.com/most", "www.client.com/least"]
    assert_equal expected, client.url_list_ordered_by_request_count

  end

  def test_client_can_return_list_of_relative_paths
    standard_payload_with_associations

    expected = "www.client.com/most"
    assert_equal expected, client.find_url_by_relative_path("most").address
  end

  def test_relative_path_exists
    standard_payload_with_associations

    assert client.relative_path_exists?("most")
    refute client.relative_path_exists?("other")

  end

  def test_it_groups_events_by_hour_for_client
    associations = standard_payload_with_associations
    client.payload_requests.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name: associations[:event],
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      key: "SHA2")
                      
    expected = {21.0=>1, 1.0=>1}
    assert_equal expected, client.event_requests_by_hour(associations[:event].name)
  end

end
