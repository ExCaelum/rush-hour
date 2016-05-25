require_relative '../test_helper' 

class UserCanClickAUrlLink < FeatureTest

  def test_user_can_click_a_url_link
    aggregate_setup

    visit("/sources/jumpstartlab")

    click_link("Dashboard: http://jumpstartlab.com/most")

    save_and_open_page

    assert page.has_content?("http://jumpstartlab.com/most")
    assert page.has_content?("Response Times")
    assert page.has_content?("Popular Referrers")
    assert page.has_content?("Popular Agents")
    assert_equal "/sources/jumpstartlab/urls/most", current_path
    assert page.has_content?("Missing_client does not exist")
  end

end
