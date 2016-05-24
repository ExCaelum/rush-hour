require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_connections_to_other_tables
    aggregate_setup

    assert_equal 12, client.payload_requests.count
    assert_equal "www.least.com", client.urls.first.address
    assert_equal "www.@referrer1.com", client.referrers.first.address
    assert_equal "GET", client.request_types.first.verb
    assert_equal "event_most", client.event_names.first.name
    assert_equal "OSX", client.user_agents.first.os
    assert_equal "1920", client.resolutions.first.width
    assert_equal "127.0.0.1", client.ips.first.address

  end

  def test_other_table_connections_to_client
    aggregate_setup

    expected = "http://jumpstartlab.com"

    assert_equal expected, @url_least.clients.first.root_url
    assert_equal expected, @referrer1.clients.first.root_url
    assert_equal expected, @request_type_most.clients.first.root_url
    assert_equal expected, @event_name_most.clients.first.root_url
    assert_equal expected, @user_agent1.clients.first.root_url
    assert_equal expected, @resolution_most.clients.first.root_url

  end

  def test_it_excludes_data_for_other_client
    aggregate_setup
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
                          client_id: @client.id + 1,
                          key: "SHA-1")

    assert_equal 12, client.payload_requests.count
  end


  def test_it_calculates_average_response_time_for_client
    aggregate_setup

    assert_equal @avg_response_time, @client.average_response_time_for_client.to_f.round(2)

  end

  def test_it_calculates_min_response_time_for_client
    aggregate_setup

    assert_equal @min_response_time, client.min_response_time_for_client
  end

  def test_it_calculates_max_response_time_for_client
    aggregate_setup

    assert_equal @max_response_time, client.max_response_time_for_client

  end

  def test_it_ids_most_frequent_request_verb_for_client
    aggregate_setup

    assert_equal @request_type_most.verb, client.most_frequent_request_type_for_client

  end

  def test_it_lists_all_request_verbs_for_client
    aggregate_setup

    assert_equal ["GET", "PATCH", "POST"], client.all_http_verbs_for_client.sort
  end

  def test_it_lists_all_resoultions_for_client
    aggregate_setup

    assert_equal 2, client.all_screen_resolutions_for_client.count

    expected = "#{@resolution_most.width}" + " x " + "#{@resolution_most.height}"
    assert_equal true, client.all_screen_resolutions_for_client.include?(expected)

  end

  def test_it_provides_breakdown_of_all_browswers_for_client
    aggregate_setup
    expected = {"Chrome"=>8, "IE"=>2, "Safari"=>2}
    assert_equal expected, client.browser_breakdown_for_client
  end


  def test_it_provides_breakdown_of_all_operating_systems_for_client
    aggregate_setup

    expected = {"OSX"=>6, "Windows"=>4, "Linux"=>2}

    assert_equal expected, client.operating_system_breakdown_for_client

  end


  def test_it_lists_all_urls_by_requests_for_client
    aggregate_setup
    expected = ["www.most.com", "www.least.com"]

    assert_equal expected, client.url_list_ordered_by_request_count
  end

  def test_client_can_return_list_of_relative_paths
    relative_url_setup

    expected = "www.relative.com/path"

    assert_equal expected, client.find_url_by_relative_path("path").address
  end

  def test_relative_path_exists
    relative_url_setup

    assert client.relative_path_exists?("path")
    assert client.relative_path_exists?("list")
    assert client.relative_path_exists?("new")
    refute client.relative_path_exists?("bad_path")
  end

  def test_it_groups_events_by_hour_for_client
    aggregate_setup
    expected = {21.0=>8, 20.0=>1}
    assert_equal expected, client.event_requests_by_hour(@event_name_most.name)
  end

end
