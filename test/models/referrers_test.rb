require_relative '../test_helper'

class ReferrerTest < Minitest::Test
  include TestHelpers

  def test_it_creates_a_referrer
    ref = Referrer.create(address: "www.turing.io")
    assert_equal "www.turing.io", ref.address
  end

  def test_referrer_validation
    ref = Referrer.create(address: "www.turing.io")
    assert ref.valid?
  end

  def test_invalid_referrer_is_not_added
    ref = Referrer.create(address: "")
    assert ref.invalid?
  end

  def test_referrer_payload_relationship
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                               responded_in: 48,
                               referrer_id: 1,
                               request_type: "GET",
                               parameters: "[]",
                               event_name: "event",
                               user_agent: "browswer and OS",
                               resolution_width: "1000",
                               resolution_height:"1000",
                               ip_id: 1,
                               url_id: 1)

    ref = Referrer.create(address: "www.turing.io")
  end

end
