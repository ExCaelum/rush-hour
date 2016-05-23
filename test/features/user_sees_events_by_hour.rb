require_relative '../test_helper'

class UserSeesSingleEventTest < FeatureTest

  def test_user_sees_single_event
    Client.create(identifier: "Client1", root_url: "www.client.com")
    EventName.create(name: "Event1")
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
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
    PayloadRequest.create(requested_at: "2013-02-16 01:38:28 -0700",
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
   PayloadRequest.create(requested_at: "2013-02-16 02:38:28 -0700",
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
   PayloadRequest.create(requested_at: "2013-02-16 23:38:28 -0700",
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
    visit('/sources/Client1/events/Event1')

    assert page.has_content?("Total requests: 4")
    assert page.has_content?("Requests by Hour for Event1")
    within('.am12') do
      assert page.has_content?("0")
    end
    within('.am1') do
      assert page.has_content?("2")
    end
    within('.am2') do
      assert page.has_content?("1")
    end
    within('.am3') do
      assert page.has_content?("0")
    end
    within('.am4') do
      assert page.has_content?("0")
    end
end


end
