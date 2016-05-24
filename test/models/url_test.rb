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
    aggregate_setup

    url = Url.first
    pr = PayloadRequest.first

    assert_equal 2, url.payload_requests.count
    assert_equal 1, url.payload_requests.first.event_name_id
    assert_equal 45, url.payload_requests.first.responded_in
    assert_equal "www.most.com", pr.url.address
  end

  def test_it_sorts_by_requested
    aggregate_setup

    assert_equal ["www.most.com", "www.least.com"], Url.most_to_least_requested
  end


  def test_response_time_list_includes_all_when_multiple_urls
    aggregate_setup

    url_least = Url.find_by(address: "www.least.com")
    url_most = Url.find_by(address: "www.most.com")

    assert_equal [45, 45], url_least.list_response_times
    assert_equal [30, 40, 55, 30, 40, 55, 30, 45, 40, 55], url_most.list_response_times
  end

  def test_returns_top_referrers
    aggregate_setup

    url = Url.find_by(address: "www.most.com")

    assert_equal ["www.@referrer1.com", "www.referrer2.com"], url.top_three_referrers
  end

  def test_url_has_verb_association
    aggregate_setup

    url = Url.find_by(address: "www.most.com")

    assert_equal ["GET", "PATCH", "POST"], url.http_verbs
  end

  def test_url_can_find_popular_agents
    aggregate_setup
    url = Url.find_by(address: "www.most.com")


    assert_equal ["OSX Chrome", "Linux Chrome", "Windows IE"], url.popular_agents
  end

  def test_it_can_find_calculate_response_time_stats_for_one_url
    aggregate_setup
    url = Url.find_by(address: "www.most.com")


    assert_equal 55, url.max_response_for_url
    assert_equal 30, url.min_response_for_url
    assert_equal 42, url.average_response_for_url.to_i
  end

end
