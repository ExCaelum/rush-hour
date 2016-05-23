require_relative '../test_helper'

class UserSeesAllEventsTest < FeatureTest

  def test_user_sees_all_events
    Client.create(identifier: "Client1", root_url: "www.client.com")
    EventName.create(name: "Event1")
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          user_agent_id: 1,
                          resolution_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1,
                          key: "SHA-1")

    assert 1, Client.count
    assert 1, EventName.count
    assert 1, PayloadRequest.count

    visit('/sources/Client1/events')

    assert page.has_content?("Client1's Events")
    assert page.has_content?("Event1")
    click_link("Event1")
    assert_equal '/sources/Client1/events/Event1', current_path
  end

end
