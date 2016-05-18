require_relative "../test_helper"

class PayloadRequestTest < Minitest::Test
  include TestHelpers

  def test_it_can_add_a_payload_request
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent: "browswer and OS",
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)
    # url = Url.create(address: "www.turing.com")
    #
    # url.payload_requests << PayloadRequest.find_by(id: 1)

    assert_equal 1, PayloadRequest.count
    assert_equal 1, PayloadRequest.first.id
    assert_equal 48, PayloadRequest.first.responded_in
  end

  def test_payload_info_stored_in_correct_format
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent: "browswer and OS",
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    assert_equal Fixnum, PayloadRequest.first.id.class
    assert_equal Time, PayloadRequest.first.requested_at.class
    assert_equal Fixnum, PayloadRequest.first.responded_in.class
  end


  def test_payload_request_can_be_found_by_id
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent: "browswer and OS",
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    time = Time.new(2013, 02, 16, 21, 38, 28, "-07:00")

    assert_equal time, PayloadRequest.find(1).requested_at
  end


  def test_it_rejects_payload_request_with_missing_data
    pr = PayloadRequest.create
    assert_equal 9, pr.errors.messages.length
    assert_equal true, pr.invalid?
    # assert_equal true, pr.errors.messages.keys.sort(:url)
  end

  def test_that_the_payload_request_is_valid
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent: "browswer and OS",
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    assert_equal true, pr.valid?
    assert_equal 0, pr.errors.messages.length
  end




end
