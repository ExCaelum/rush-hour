require_relative '../test_helper'

class UserSeesAllClientUrlsTest < FeatureTest

  def test_user_sees_all_client_urls
    Client.create(identifier: "Client1", root_url: "www.client.com")

    Url.create(address: "www.client.com/blog")
    Url.create(address: "www.client.com/blog")

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



    
  end
