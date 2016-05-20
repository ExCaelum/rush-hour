require_relative "../test_helper"
require_relative "client_helper"

class ClientTest < Minitest::Test
  include TestHelpers
  include ClientHelper

  def test_client_relationships_through_payload_requests
    generate_payload
    assert_equal 1, Client.all.count
    client = Client.find(1)

    assert_equal 1, client.payload_requests.count

  end

  def test_relationships_through_payload_requests

    generate_payload
    assert_equal 1, PayloadRequest.all.length
    pr = PayloadRequest.find(1)

    assert_kind_of PayloadRequest, pr

    assert_kind_of Time, pr.requested_at
    assert_equal Time.parse("2013-02-16 21:38:28 -0700"), pr.requested_at

    assert_kind_of Numeric, pr.responded_in
    assert_equal 48, pr.responded_in 
assert_kind_of String, pr.parameters
    assert_equal "[]", pr.parameters

    assert_kind_of Referrer, pr.referrer
    assert_equal "www.example.com", pr.referrer.address

    assert_kind_of RequestType, pr.request_type
    assert_equal "GET", pr.request_type.verb

    assert_kind_of EventName, pr.event_name
    assert_equal "event", pr.event_name.name

    assert_kind_of Resolution, pr.resolution
    assert_equal "1000", pr.resolution.width
    assert_equal "1000", pr.resolution.height

    assert_kind_of UserAgent, pr.user_agent 
    assert_equal "OS", pr.user_agent.os
    assert_equal "Browser", pr.user_agent.browser

    assert_kind_of Ip, pr.ip
    assert_equal "100.00.00.00", pr.ip.address
  
    assert_kind_of Url, pr.url
    assert_equal "www.example.com", pr.url.address

    assert_kind_of Client, pr.client
    assert_equal "BestBuy", pr.client.identifier
    assert_equal "www.bestbuy.com", pr.client.root_url
  end

  def test_client
  end
       
    #Client.create(identifier: "KingSoopers", root_url: "www.KingSoopers.com")
    #url = Url.create(address: "www.BestBuy.com/cameras")

    #assert_equal "www.BestBuy.com/cameras", c1.urls.first.address
    #assert_equal "www.BestBuy.com", url.clients.first.root_url

end
