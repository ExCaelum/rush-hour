require_relative '../test_helper'

class ReceiveClientPayloadTest < Minitest::Test
  include Rack::Test::Methods
  include TestHelpers

  def app
    RushHourApp
  end

  def test_it_returns_400_error_for_missing_payload

    Client.create(identifier: "Client1", root_url: "www.client.com")

    post '/sources/Client1/data', {}

    assert_equal 0, PayloadRequest.count
    assert_equal 400, last_response.status
    assert_equal "Payload data was not provided.", last_response.body

    post '/sources/Client1/data', {payload: {}}

    assert_equal 0, PayloadRequest.count
    assert_equal 400, last_response.status
    assert_equal "Payload data was not provided.", last_response.body

  end

  def test_it_returns_403_error_for_duplicate_payload

    skip

    Client.create(identifier: "Client1", root_url: "www.client.com")

    payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName":"socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    PayloadRequest.record_payload(payload, "Client1")
    assert_equal 1, PayloadRequest.count

    post '/sources/Client1/data', {payload: payload}

    assert_equal 1, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "This payload was already received.", last_response.body

  end

  def test_it_returns_403_error_for_unregistered_identifier

    payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName":"socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    post '/sources/Client2/data', {payload: payload}

    assert_equal 0, PayloadRequest.count
    assert_equal 403, last_response.status
    assert_equal "Client2 is not a registered application.", last_response.body

  end

  def test_it_returns_200_for_successful_transaction

    Client.create(identifier: "Client1", root_url: "www.client.com")

    payload = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName":"socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'

    post '/sources/Client1/data', {payload: payload}

    assert_equal 1, PayloadRequest.count
    assert_equal 200, last_response.status

  end




  end
