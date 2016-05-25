require_relative '../test_helper'

class UserAgentTest < Minitest::Test
  include TestHelpers

  def test_it_creates_user_agent
    UserAgent.create(os: "osX", browser: "Chrome")

    assert_equal 1, UserAgent.count
  end

  def test_it_invalidates_user_agent
    ua = UserAgent.create

    assert_equal true, ua.invalid?
    assert_equal 2, ua.errors.messages.length
  end

  def test_user_agent_payload_connection
    user_agent = UserAgent.create

    assert user_agent.respond_to?(:payload_requests)
  end

  def test_user_agent_attributes_are_accessible
    ua = UserAgent.create(os: "osX", browser: "Chrome")

    assert_equal "osX", ua.os
    assert_equal "Chrome", ua.browser

  end


  def test_user_agent_payload_requests_relationship
    associations = standard_payload_with_associations

    assert_equal 1, associations[:user_agent].payload_requests.count
    assert_equal "Client", associations[:user_agent].payload_requests.first.client.identifier

  end
end
