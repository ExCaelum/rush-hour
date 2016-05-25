require_relative '../test_helper' 

class UserGetsClientNotFoundTest < FeatureTest

  def test_user_gets_client_does_not_exist_page
    aggregate_setup

    visit('/sources/MISSING_CLIENT')

    assert page.has_content?("Missing_client does not exist")
  end

end
