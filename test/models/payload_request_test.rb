require_relative "../test_helper"

class PayloadRequestTest < Minitest::Test
  include TestHelpers


  def test_can_write_raw_json_to_database
    raw_json = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    Client.create(identifier: "client1", root_url: "www.example.com")
    PayloadRequest.record_payload(raw_json, "client1")

    assert_equal 1, PayloadRequest.count

    pr = PayloadRequest.find(1)

    assert_kind_of Time, pr.requested_at
    assert_equal Time.parse("2013-02-16 21:38:28 -0700"), pr.requested_at

    assert_kind_of Numeric, pr.responded_in
    assert_equal 37, pr.responded_in

    assert_kind_of Fixnum, pr.client_id
    assert_equal 1, pr.client_id

    assert_equal 1, Referrer.count
    assert_equal 1, Resolution.count
    assert_equal 1, UserAgent.count
    assert PayloadRequest.first.key
  end

  def test_it_handles_similar_payload_requests
    raw_json_1 = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    Client.create(identifier: "client1", root_url: "www.example.com")
    PayloadRequest.record_payload(raw_json_1, "client1")

    raw_json_2 = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2014-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    PayloadRequest.record_payload(raw_json_2, "client1")

    assert_equal 2, PayloadRequest.count
    assert_equal 1, Referrer.count
    assert_equal 1, Resolution.count
    assert_equal 1, UserAgent.count
    assert PayloadRequest.first.key

  end

  def test_it_can_add_a_payload_request
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")

    assert_equal 1, PayloadRequest.count
    assert_equal 1, PayloadRequest.first.id
    assert_equal 48, PayloadRequest.first.responded_in
    assert "SHA-1", PayloadRequest.first.key
  end

  def test_payload_info_stored_in_correct_format
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")

    assert_equal Fixnum, PayloadRequest.first.id.class
    assert_equal Time, PayloadRequest.first.requested_at.class
    assert_equal Fixnum, PayloadRequest.first.responded_in.class
  end

  def test_payload_request_can_be_found_by_id
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          user_agent_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")

    time = Time.new(2013, 02, 16, 21, 38, 28, "-07:00")

    assert_equal time, PayloadRequest.find(1).requested_at
  end


  def test_it_rejects_payload_request_with_missing_data
    pr = PayloadRequest.create
    assert_equal 12, pr.errors.messages.length
    assert_equal true, pr.invalid?
  end

  def test_that_the_payload_request_is_valid
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 48,
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               resolution_id: 1,
                               user_agent_id: 1,
                               ip_id: 1,
                               url_id: 1, client_id: 1, key: "SHA-1")

    assert_equal true, pr.valid?
    assert_equal 0, pr.errors.messages.length
  end

  def test_that_the_payload_request_can_find_all_browsers
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 2,
                          ip_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")
    UserAgent.create(os: "Macintosh", browser: "Chrome")
    UserAgent.create(os: "Macintosh", browser: "Safari")

    assert_equal ["Chrome", "Safari"], PayloadRequest.web_browser_breakdown.sort
  end

  def test_that_the_payload_request_can_find_all_os
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 2,
                          ip_id: 1,
                          url_id: 1, client_id: 1, key: "SHA-1")
    UserAgent.create(os: "Macintosh", browser: "Chrome")
    UserAgent.create(os: "Windows", browser: "Safari")

    assert_equal ["Macintosh", "Windows"], PayloadRequest.os_breakdown.sort
  end

  def test_it_can_find_calculate_response_time_stats_for_all_urls
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 100,
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               user_agent_id: 1,
                               resolution_id: 1,
                               ip_id: 1,
                               url_id: 1, client_id: 1, key: "SHA-1")

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 20,
                               referrer_id: 1,
                               request_type_id: 1,
                               parameters: "[]",
                               event_name_id: 1,
                               user_agent_id: 1,
                               resolution_id: 1,
                               ip_id: 1,
                               url_id: 2, client_id: 1, key: "SHA-1")

    assert_equal 2, PayloadRequest.count
    assert_equal 100, PayloadRequest.max_response
    assert_equal 20, PayloadRequest.min_response
    assert_equal 60, PayloadRequest.average_response
  end

  def test_that_parsed_json_has_client_key_value_pair
    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    raw_payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    parsed_payload = PayloadParser.parse_json(raw_payload)
    parsed_payload[:client] = Client.find_by(identifier: "BestBuy")

    assert_equal client, parsed_payload[:client]
  end

  def test_we_generate_a_sha_from_payload
    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    raw_payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    parsed_payload = PayloadParser.parse_json(raw_payload)
    parsed_payload[:client] = Client.find_by(identifier: "BestBuy")

    key = Digest::SHA1.hexdigest(parsed_payload.to_s)

    assert_equal String, key.class
    assert_equal 40, key.length
  end

  def test_duplicates_payloads_share_same_sha
    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    raw_payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    parsed_payload = PayloadParser.parse_json(raw_payload)
    parsed_payload[:client] = Client.find_by(identifier: "BestBuy")

    key = Digest::SHA1.hexdigest(parsed_payload.to_s)
    key2 = Digest::SHA1.hexdigest(parsed_payload.to_s)
    key3 = Digest::SHA1.hexdigest(parsed_payload.to_s)

    assert_equal key, key2
    assert_equal key, key3
  end

  def test_if_unique_shas_are_generated_for_different_payloads
    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    raw_payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    client2 = Client.create(identifier: "MicroCenter", root_url: "www.MicroCenter.com")
    raw_payload2 = '{"url":"http://pivotallabs.com/blog","requestedAt":"2014-02-16 21:38:28 -0700","respondedIn":57,"referredBy":"http://pivotallab.com","requestType":"POST","parameters":[],"eventName": "nonsocialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    parsed_payload = PayloadParser.parse_json(raw_payload)
    parsed_payload[:client] = Client.find_by(identifier: "BestBuy")
    parsed_payload2 = PayloadParser.parse_json(raw_payload2)
    parsed_payload2[:client] = Client.find_by(identifier: "MicroCenter")

    key = Digest::SHA1.hexdigest(parsed_payload.to_s)
    key2 = Digest::SHA1.hexdigest(parsed_payload2.to_s)

    refute_equal key, key2
  end

  def test_duplicate_payload_is_rejected
    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    client_identifier = "BestBuy"
    raw_payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    PayloadRequest.record_payload(raw_payload, client_identifier)
    assert_equal 1, PayloadRequest.count

    boolean = PayloadRequest.duplicate?(raw_payload, client_identifier)
    assert_equal true, boolean
  end

  def test_non_duplicate_payload_is_passed_through
    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    client_identifier = "BestBuy"
    raw_payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    boolean = PayloadRequest.duplicate?(raw_payload, client_identifier)
    assert_equal false, boolean
  end

end
