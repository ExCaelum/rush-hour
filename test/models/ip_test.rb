require_relative '../test_helper'

class IpTest < Minitest::Test
  include TestHelpers

  def test_it_creates_an_ip
    ip = Ip.create(address: "127.0.0.1")

    assert_equal ("127.0.0.1"), ip.address
  end

  def test_ip_payload_requests_relationship
    ip = Ip.create(address: "127.0.0.1")
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1)
    assert_equal "127.0.0.1", pr.ip.address
  end
end
