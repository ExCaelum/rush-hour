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

  def test_url_payload_connection
    url = Url.create

    assert url.respond_to?(:payload_requests)
  end

  def test_url_payload_requests_relationship
    associations = standard_payload_with_associations

    assert_equal 1, associations[:url].payload_requests.count
    assert_equal "Client", associations[:url].payload_requests.first.client.identifier
    assert_equal "www.client.com/most", associations[:payload_request].url.address
  end


  def test_it_sorts_by_requested
    standard_payload_with_associations
    standard_payload_with_associations
    least_url = Url.create(address: "www.client.com/least")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url: least_url,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 100,
                      key: "SHA2")

    assert_equal ["www.client.com/most", "www.client.com/least"], Url.most_to_least_requested

  end


  def test_response_time_list_includes_all_when_multiple_urls
    aggregate_setup

    url_least = Url.find_by(address: "www.least.com")
    url_most = Url.find_by(address: "www.most.com")

    assert_equal [45, 45], url_least.list_response_times
    assert_equal [30, 30, 30, 40, 40, 40, 45, 55, 55, 55], url_most.list_response_times.sort
  end

  def test_returns_top_referrers
    aggregate_setup

    url = Url.find_by(address: "www.most.com")

    assert_equal ["www.@referrer1.com", "www.referrer2.com"], url.top_three_referrers
  end

  def test_url_has_verb_association
    aggregate_setup

    url = Url.find_by(address: "www.most.com")

    assert_equal ["GET", "PATCH", "POST"], url.http_verbs.sort
  end

  def test_url_can_find_popular_agents
    aggregate_setup
    url = Url.find_by(address: "www.most.com")

    assert_equal "Linux Chrome", url.popular_agents.sort.first
    assert_equal 3, url.popular_agents.count
  end

  def test_it_can_find_calculate_response_time_stats_for_one_url
    aggregate_setup
    url = Url.find_by(address: "www.most.com")


    assert_equal 55, url.max_response_for_url
    assert_equal 30, url.min_response_for_url
    assert_equal 42, url.average_response_for_url.to_i
  end

end
