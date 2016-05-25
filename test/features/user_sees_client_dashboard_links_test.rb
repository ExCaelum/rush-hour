require_relative '../test_helper'

class UserSeesAllClientUrlsTest < FeatureTest

  def test_user_sees_all_client_urls
    aggregate_setup

    visit("/sources/jumpstartlab")

    assert page.has_content?("Jumpstartlab Payload Statistics")
    assert page.has_content?("All Requested URLs (link to URL dashboard)")
    assert page.has_content?("HTTP Verbs")
    assert page.has_content?("Web Browsers")
    assert page.has_content?("Operating Systems")
    assert page.has_content?("Resolutions")
  end
end
