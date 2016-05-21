require_relative '../test_helper'

class ClientGetsEventNotFoundTest < FeatureTest

  def test_user_sees_not_found_page
    Client.create(identifier: "Client1", root_url: "www.client.com")
    EventName.create(name: "Event1")
    EventName.create(name: "Event2")
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
                               client_id: 1)

    visit('/sources/Client1/events/Event2')


    assert page.has_content?("Event2 was not found.")
    click_link("See List of Events")
    assert_equal '/sources/Client1/events', current_path
    assert page.has_content?("Event1")
  end

end
