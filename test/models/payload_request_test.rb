require_relative "../test_helper"

class PayloadRequestTest < Minitest::Test
  include TestHelpers


  def test_can_write_raw_json_to_database
    raw_json = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    Client.create(identifier: "client1", root_url: "www.example.com")
    PayloadCreator.record_payload(raw_json, "client1")

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

  def test_it_does_not_duplicate_db_entries_for_same_entities
    raw_json_1 = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    Client.create(identifier: "client1", root_url: "www.example.com")
    PayloadCreator.record_payload(raw_json_1, "client1")

    raw_json_2 = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2014-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    PayloadCreator.record_payload(raw_json_2, "client1")

    assert_equal 2, PayloadRequest.count
    assert_equal 1, Referrer.count
    assert_equal 1, Resolution.count
    assert_equal 1, UserAgent.count
    assert PayloadRequest.first.key

  end

  def test_it_can_add_a_payload_request
    standard_payload_with_associations

    assert_equal 1, PayloadRequest.count
    assert_equal 1, PayloadRequest.first.id
    assert_equal 10, PayloadRequest.first.responded_in
    assert_equal "[]", PayloadRequest.first.parameters
    assert_equal "1", PayloadRequest.first.resolution.width
    assert_equal "www.MostReferrer.com", PayloadRequest.first.referrer.address
    assert_equal "MostOS", PayloadRequest.first.user_agent.os
    assert_equal "Client", PayloadRequest.first.client.identifier
    assert_equal "SHA1", PayloadRequest.first.key
  end

  def test_payload_info_stored_in_correct_format
    standard_payload_with_associations

    assert_kind_of Fixnum, PayloadRequest.first.id
    assert_respond_to PayloadRequest.first, :id
    assert_kind_of Time, PayloadRequest.first.requested_at
    assert_kind_of Fixnum, PayloadRequest.first.responded_in
    assert_kind_of Fixnum, PayloadRequest.first.responded_in
    assert_kind_of String, PayloadRequest.first.key
    assert_kind_of String, PayloadRequest.first.parameters

    assert_kind_of Referrer, PayloadRequest.first.referrer
    assert_kind_of RequestType, PayloadRequest.first.request_type
    assert_kind_of EventName, PayloadRequest.first.event_name
    assert_kind_of UserAgent, PayloadRequest.first.user_agent
    assert_kind_of Resolution, PayloadRequest.first.resolution
    assert_kind_of Client, PayloadRequest.first.client
    assert_kind_of Ip, PayloadRequest.first.ip
  end

  def test_payload_request_can_be_found_by_id
    standard_payload_with_associations

    time_zone = 'Mountain Time (US & Canada)'
    time = Time.new(2013, 02, 16, 21, 38, 28, "-07:00").in_time_zone(time_zone)
    assert_equal time, PayloadRequest.first.requested_at.in_time_zone(time_zone)
  end


  def test_it_rejects_payload_request_with_missing_data
    pr = PayloadRequest.create
    assert_equal 12, pr.errors.messages.length
    assert_equal true, pr.invalid?
  end

  def test_that_the_payload_request_is_valid
    standard_payload_with_associations

    pr = PayloadRequest.find(1)
    assert_equal true, pr.valid?
    assert_equal 0, pr.errors.messages.length
  end

  def test_that_the_payload_request_can_find_all_browsers
    standard_payload_with_associations
    user_agent = UserAgent.create(os: "OtherOS", browser: "OtherBrowser")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent: user_agent,
                      ip_id: 1,
                      client_id: 1,
                      key: "SHA2")


    assert_equal ["MostBrowser", "OtherBrowser"], PayloadRequest.web_browser_breakdown.sort.uniq
  end

  def test_that_the_payload_request_can_find_all_os
    standard_payload_with_associations
    user_agent = UserAgent.create(os: "OtherOS", browser: "OtherBrowser")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent: user_agent,
                      ip_id: 1,
                      client_id: 1,
                      key: "SHA2")

    assert_equal ["MostOS", "OtherOS"], PayloadRequest.os_breakdown.sort.uniq
  end

  def test_it_can_find_calculate_response_time_stats_for_all_urls
    standard_payload_with_associations
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                      responded_in: 20,
                      parameters: "[]",
                      url_id: 1,
                      event_name_id: 1,
                      request_type_id: 1,
                      resolution_id: 1,
                      referrer_id: 1,
                      user_agent_id: 1,
                      ip_id: 1,
                      client_id: 2,
                      key: "SHA2")

    assert_equal 2, PayloadRequest.count
    assert_equal 20, PayloadRequest.max_response
    assert_equal 10, PayloadRequest.min_response
    assert_equal 15, PayloadRequest.average_response.to_i
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

    PayloadCreator.record_payload(raw_payload, client_identifier)
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
