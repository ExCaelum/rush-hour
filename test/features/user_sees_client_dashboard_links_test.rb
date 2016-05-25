require_relative '../test_helper'

class UserSeesAllClientUrlsTest < FeatureTest

  def test_user_sees_all_client_urls
    aggregate_setup

    visit("/sources/jumpstartlab")

    within "div#stats" do
      assert page.has_content?("Jumpstartlab Payload Statistics")
    end

    within "div#all-urls" do
      assert page.has_content?("All Requested URLs (link to URL dashboard)")
    end

    within "div#verbs" do
      assert page.has_content?("HTTP Verbs")
    end

    within "div#browsers" do
      assert page.has_content?("Web Browsers")
    end

    within "div#os" do
      assert page.has_content?("Operating Systems")
    end

    within "div#resolutions" do
      assert page.has_content?("Resolutions")
    end
  end
end
