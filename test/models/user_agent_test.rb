require_relative '../test_helper'

class UserAgentTest < Minitest::Test
  include TestHelpers

  def test_it_creates_user_agent
    ua = UserAgent.create(os: "osX", browser: "Chrome")

    assert_equal "osX", ua.os
  end

  def test_it_invalidates_user_agent
    ua = UserAgent.create

    assert_equal true, ua.invalid?
    assert_equal 2, ua.errors.messages.length
  end

  def test_user_agent_payload_requests_relationship
    pr = PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referred_by: "www.referrer.com",
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip: "100.00.00.00",
                          url_id: 1)

    ua = UserAgent.create(os: "osX", browser: "Chrome")

    assert_equal 1, ua.payload_requests.count
    assert_equal 1, ua.payload_requests.first.event_name_id
    assert_equal 48, ua.payload_requests.first.responded_in
    assert_equal "Chrome", pr.user_agent.browser
  end
end
