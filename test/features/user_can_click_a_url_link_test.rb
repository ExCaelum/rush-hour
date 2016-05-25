require_relative '../test_helper' 

class UserCanClickAUrlLink < FeatureTest

  def test_user_can_click_a_url_link
    aggregate_setup


    visit("/sources/jumpstartlab")

    save_and_open_page

    click_link("Dashboard: http://jumpstartlab.com/most")

    assert page.has_content?("http://jumpstartlab.com/most")

    within "table#response-times" do
      assert page.has_content?("Average Response Time")
      assert page.has_content?("Minimum Response Time")
      assert page.has_content?("Maximum Response Time")
    end
      
    within "div#all-times" do
      assert page.has_content?("55")
    end

    within "div#referrers" do
      assert page.has_content?("Popular Referrers")
      assert page.has_content?("www.@referrer1.com")
    end

    within "div#agents" do
      assert page.has_content?("Popular Agents")
      assert page.has_content?("OSX Chrome")
      assert page.has_content?("Linux Chrome")
      assert page.has_content?("Windows Chrome")
    end

    assert_equal "/sources/jumpstartlab/urls/most", current_path
  end

end
