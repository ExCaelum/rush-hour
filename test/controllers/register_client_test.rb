require_relative '../test_helper'

class RegisterClientTest < Minitest::Test
  include Rack::Test::Methods
  include TestHelpers

  def app
    RushHourApp
  end

  def test_it_registers_a_client_with_valid_attributes
    post '/sources', {identifier: "Client1", rootUrl: "www.client1.com"}

    assert_equal 1, Client.count
    assert_equal "www.client1.com", Client.find(1).root_url
    assert_equal 200, last_response.status
    assert_equal "{\"Identifier\": Client1}", last_response.body

  end

  def test_it_will_not_register_a_client_with_invalid_attributes
    post '/sources', {rootUrl: "www.client1.com"}

    assert_equal 0, Client.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body

  end

  def test_it_will_not_register_a_client_with_invalid_attributes
    Client.create(identifier: "Client1", root_url: "www.client.com")

    post '/sources', {identifier: "Client1", rootUrl: "www.client1.com"}

    assert_equal 1, Client.count
    assert_equal 403, last_response.status
    assert_equal "Client with this CLIENT1 identifier is already registered.", last_response.body

  end

end
