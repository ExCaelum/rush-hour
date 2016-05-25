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
    standard_payload_with_associations

    assert_kind_of Referrer, PayloadRequest.first.referrer
  end

  def test_referrer_payload_connection
    referrer = Referrer.create

    assert referrer.respond_to?(:payload_requests)
  end

end
