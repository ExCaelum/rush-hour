require_relative '../test_helper'

class UserSeesSingleEventTest < FeatureTest

  def test_user_sees_single_event

    aggregate_setup


    visit('/sources/jumpstartlab/events/event_most')
    save_and_open_page

    assert page.has_content?("Total requests: 9")
    assert page.has_content?("Requests by Hour for Event_most")
    within('.am12') do
      assert page.has_content?("0")
    end
    within('.am1') do
      assert page.has_content?("0")
    end
    within('.am2') do
      assert page.has_content?("0")
    end
    within('.am3') do
      assert page.has_content?("0")
    end
    within('.am4') do
      assert page.has_content?("0")
    end
end


end
