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
    aggregate_setup
    ua = UserAgent.find_by(browser: "Chrome")
    pr = PayloadRequest.first

    assert_equal 4, ua.payload_requests.count
    assert_equal 2, ua.payload_requests.first.event_name_id
    assert_equal 30, ua.payload_requests.first.responded_in
    assert_equal "Chrome", pr.user_agent.browser
  end
end
