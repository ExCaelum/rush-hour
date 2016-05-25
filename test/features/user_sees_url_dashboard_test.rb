require_relative '../test_helper'

class UserSeesUrlsDashboard < FeatureTest

  def test_user_sees_all_client_urls
    aggregate_setup

    visit("/sources/jumpstartlab/urls/least")

    within "div#all-times" do
      assert page.has_content?("All Response Times")
    end

    within "div#times" do
      assert page.has_content?("Response Times")
    end

    within "div#referrers" do
      assert page.has_content?("Popular Referrers")
    end


      


  end
end
