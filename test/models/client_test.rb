require_relative "../test_helper"

class ClientTest < Minitest::Test
  include TestHelpers

  def test_client_connections
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)
    c1 = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    Client.create(identifier: "KingSoopers", root_url: "www.KingSoopers.com")
    url = Url.create(address: "www.BestBuy.com/cameras")

    assert_equal 2, c1.payload_requests.length
    assert_equal "www.BestBuy.com/cameras", c1.urls.first.address
    assert_equal "www.BestBuy.com", url.clients.first.root_url
  end

  def test_it_calculates_average_response_time_for_client
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    assert_equal 49, client.average_response_time_for_client


  end

  def test_it_calculates_min_response_time_for_client
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    assert_equal 48, client.min_response_time_for_client


  end

  def test_it_calculates_max_response_time_for_client
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    assert_equal 50, client.max_response_time_for_client


  end

  def test_it_calculates_max_response_time_for_client
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    req1 = RequestType.create(verb: "GET")
    req2 = RequestType.create(verb: "POST")
    assert_equal req2.verb, client.most_frequent_request_type_for_client


  end

  def test_it_calculates_max_response_time_for_client
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
    req1 = RequestType.create(verb: "GET")
    req2 = RequestType.create(verb: "POST")
    req3 = RequestType.create(verb: "PUT")
    req4 = RequestType.create(verb: "DELETE")
    assert_equal ["GET", "POST"], client.all_http_verbs_for_client.sort
  end

  def test_it_lists_all_resoultions_for_client
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 48,
                            referrer_id: 1,
                            request_type_id: 1,
                            parameters: "[]",
                            event_name_id: 1,
                            resolution_id: 1,
                            user_agent_id: 1,
                            ip_id: 1,
                            url_id: 1,
                            client_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 50,
                            referrer_id: 1,
                            request_type_id: 2,
                            parameters: "[]",
                            event_name_id: 1,
                            resolution_id: 2,
                            user_agent_id: 1,
                            ip_id: 1,
                            url_id: 1,
                            client_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 50,
                            referrer_id: 1,
                            request_type_id: 2,
                            parameters: "[]",
                            event_name_id: 1,
                            resolution_id: 3,
                            user_agent_id: 1,
                            ip_id: 1,
                            url_id: 1,
                            client_id: 1)

      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 50,
                            referrer_id: 1,
                            request_type_id: 2,
                            parameters: "[]",
                            event_name_id: 1,
                            resolution_id: 3,
                            user_agent_id: 1,
                            ip_id: 1,
                            url_id: 1,
                            client_id: 1)
      PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                            responded_in: 100,
                            referrer_id: 1,
                            request_type_id: 1,
                            parameters: "[]",
                            event_name_id: 1,
                            resolution_id: 4,
                            user_agent_id: 1,
                            ip_id: 1,
                            url_id: 1,
                            client_id: 2)

      client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
      Resolution.create(height: '1', width: '1')
      Resolution.create(height: '2', width: '1')
      Resolution.create(height: '3', width: '1')
      Resolution.create(height: '4', width: '1')

      assert_equal true, client.all_screen_resolutions_for_client.include?("1 x 1")
      assert_equal true, client.all_screen_resolutions_for_client.include?("1 x 2")
      assert_equal true, client.all_screen_resolutions_for_client.include?("1 x 3")
      assert_equal false, client.all_screen_resolutions_for_client.include?("1 x 4")
      assert_equal ["1 x 1", "1 x 2", "1 x 3"], client.all_screen_resolutions_for_client.uniq.sort


    end

    def test_it_provides_breakdown_of_all_browswers_for_client
        PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                              responded_in: 48,
                              referrer_id: 1,
                              request_type_id: 1,
                              parameters: "[]",
                              event_name_id: 1,
                              resolution_id: 1,
                              user_agent_id: 1,
                              ip_id: 1,
                              url_id: 1,
                              client_id: 1)
        PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                              responded_in: 50,
                              referrer_id: 1,
                              request_type_id: 2,
                              parameters: "[]",
                              event_name_id: 1,
                              resolution_id: 2,
                              user_agent_id: 2,
                              ip_id: 1,
                              url_id: 1,
                              client_id: 1)
        PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                              responded_in: 50,
                              referrer_id: 1,
                              request_type_id: 2,
                              parameters: "[]",
                              event_name_id: 1,
                              resolution_id: 3,
                              user_agent_id: 1,
                              ip_id: 1,
                              url_id: 1,
                              client_id: 1)

        PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                              responded_in: 50,
                              referrer_id: 1,
                              request_type_id: 2,
                              parameters: "[]",
                              event_name_id: 1,
                              resolution_id: 3,
                              user_agent_id: 1,
                              ip_id: 1,
                              url_id: 1,
                              client_id: 1)
        PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                              responded_in: 100,
                              referrer_id: 1,
                              request_type_id: 1,
                              parameters: "[]",
                              event_name_id: 1,
                              resolution_id: 4,
                              user_agent_id: 3,
                              ip_id: 1,
                              url_id: 1,
                              client_id: 2)

        client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
        UserAgent.create(browser: 'IE', os: 'Windows')
        UserAgent.create(browser: 'Chrome', os: 'Windows')
        UserAgent.create(browser: 'Firefox', os: 'Windows')

        expected = {"IE" => 3, "Chrome" => 1}
        assert_equal expected, client.browser_breakdown_for_client


      end

      def test_it_provides_breakdown_of_all_operating_systems_for_client
          PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                responded_in: 48,
                                referrer_id: 1,
                                request_type_id: 1,
                                parameters: "[]",
                                event_name_id: 1,
                                resolution_id: 1,
                                user_agent_id: 1,
                                ip_id: 1,
                                url_id: 1,
                                client_id: 1)
          PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                responded_in: 50,
                                referrer_id: 1,
                                request_type_id: 2,
                                parameters: "[]",
                                event_name_id: 1,
                                resolution_id: 2,
                                user_agent_id: 2,
                                ip_id: 1,
                                url_id: 1,
                                client_id: 1)
          PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                responded_in: 50,
                                referrer_id: 1,
                                request_type_id: 2,
                                parameters: "[]",
                                event_name_id: 1,
                                resolution_id: 3,
                                user_agent_id: 1,
                                ip_id: 1,
                                url_id: 1,
                                client_id: 1)

          PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                responded_in: 50,
                                referrer_id: 1,
                                request_type_id: 2,
                                parameters: "[]",
                                event_name_id: 1,
                                resolution_id: 3,
                                user_agent_id: 1,
                                ip_id: 1,
                                url_id: 1,
                                client_id: 1)
          PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                responded_in: 100,
                                referrer_id: 1,
                                request_type_id: 1,
                                parameters: "[]",
                                event_name_id: 1,
                                resolution_id: 4,
                                user_agent_id: 3,
                                ip_id: 1,
                                url_id: 1,
                                client_id: 2)

          client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
          UserAgent.create(browser: 'IE', os: 'Windows')
          UserAgent.create(browser: 'Chrome', os: 'OSX')
          UserAgent.create(browser: 'Firefox', os: 'Linux')
          expected = {"Windows" => 3, "OSX" => 1}

          assert_equal expected, client.operating_system_breakdown_for_client


        end

        def test_it_lists_all_urls_by_requests_for_client
            PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                  responded_in: 48,
                                  referrer_id: 1,
                                  request_type_id: 1,
                                  parameters: "[]",
                                  event_name_id: 1,
                                  resolution_id: 1,
                                  user_agent_id: 1,
                                  ip_id: 1,
                                  url_id: 1,
                                  client_id: 1)
            PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                  responded_in: 50,
                                  referrer_id: 1,
                                  request_type_id: 2,
                                  parameters: "[]",
                                  event_name_id: 1,
                                  resolution_id: 2,
                                  user_agent_id: 2,
                                  ip_id: 1,
                                  url_id: 3,
                                  client_id: 1)
            PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                  responded_in: 50,
                                  referrer_id: 1,
                                  request_type_id: 2,
                                  parameters: "[]",
                                  event_name_id: 1,
                                  resolution_id: 3,
                                  user_agent_id: 1,
                                  ip_id: 1,
                                  url_id: 3,
                                  client_id: 1)

            PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                  responded_in: 50,
                                  referrer_id: 1,
                                  request_type_id: 2,
                                  parameters: "[]",
                                  event_name_id: 1,
                                  resolution_id: 3,
                                  user_agent_id: 1,
                                  ip_id: 1,
                                  url_id: 3,
                                  client_id: 1)
            PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                                  responded_in: 100,
                                  referrer_id: 1,
                                  request_type_id: 1,
                                  parameters: "[]",
                                  event_name_id: 1,
                                  resolution_id: 4,
                                  user_agent_id: 3,
                                  ip_id: 1,
                                  url_id: 1,
                                  client_id: 2)

            client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
            Url.create(address: "www.test.com")
            Url.create(address: "www.test.com/list")
            Url.create(address: "www.test.com/new")
            expected = ["www.test.com/new", "www.test.com"]

            assert_equal expected, client.url_list_ordered_by_request_count

  end

  def test_client_can_return_list_of_relative_paths
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 2,
                          user_agent_id: 2,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 3,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 3,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 2,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 4,
                          user_agent_id: 3,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.test.com")
    Url.create(address: "www.test.com")
    Url.create(address: "www.test.com/list")
    Url.create(address: "www.test.com/new")

    result = client.find_url_by_relative_path("list")

    assert_equal "www.test.com/list", result.address
  end

  def test_relative_path_exists
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 48,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 1,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 2,
                          user_agent_id: 2,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 3,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 3,
                          client_id: 1)

    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 50,
                          referrer_id: 1,
                          request_type_id: 2,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 3,
                          user_agent_id: 1,
                          ip_id: 1,
                          url_id: 2,
                          client_id: 1)
    PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                          responded_in: 100,
                          referrer_id: 1,
                          request_type_id: 1,
                          parameters: "[]",
                          event_name_id: 1,
                          resolution_id: 4,
                          user_agent_id: 3,
                          ip_id: 1,
                          url_id: 1,
                          client_id: 2)

    client = Client.create(identifier: "BestBuy", root_url: "www.test.com")
    Url.create(address: "www.test.com")
    Url.create(address: "www.test.com/list")
    Url.create(address: "www.test.com/new")

    assert client.relative_path_exists?("list")
    assert client.relative_path_exists?("new")
    refute client.relative_path_exists?("gokart")
  end






  def test_it_groups_events_by_hour_for_client
  PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                        responded_in: 48,
                        referrer_id: 1,
                        request_type_id: 1,
                        parameters: "[]",
                        event_name_id: 1,
                        resolution_id: 1,
                        user_agent_id: 1,
                        ip_id: 1,
                        url_id: 1,
                        client_id: 1)
  PayloadRequest.create(requested_at: "2013-02-16 21:38:28 -0700",
                        responded_in: 48,
                        referrer_id: 1,
                        request_type_id: 1,
                        parameters: "[]",
                        event_name_id: 1,
                        resolution_id: 1,
                        user_agent_id: 1,
                        ip_id: 1,
                        url_id: 1,
                        client_id: 1)
  PayloadRequest.create(requested_at: "2013-02-16 20:38:28 -0700",
                        responded_in: 48,
                        referrer_id: 1,
                        request_type_id: 1,
                        parameters: "[]",
                        event_name_id: 1,
                        resolution_id: 1,
                        user_agent_id: 1,
                        ip_id: 1,
                        url_id: 1,
                        client_id: 1)
  client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
  event = EventName.create(name: "event1")

  expected = {21.0 =>2, 20.0 =>1}
  assert_equal expected, client.event_requests_by_hour("event1")
end

def test_groups_events_by_hour_returns_empty_if_no_requests

  client = Client.create(identifier: "BestBuy", root_url: "www.BestBuy.com")
  event = EventName.create(name: "event1")

  assert_equal ({}), client.event_requests_by_hour("event1")
end



end
