require_relative '../test_helper'

class IpTest < Minitest::Test
  include TestHelpers

  def test_it_creates_an_ip
    ip = Ip.create(address: "127.0.0.1")

    assert_equal ("127.0.0.1"), ip.address
  end

  def test_ip_payload_requests_relationship
    standard_payload_with_associations

    assert_equal "ip", PayloadRequest.first.ip.address
  end
end
