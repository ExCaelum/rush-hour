require_relative '../test_helper'

class UserSeesAllEventsTest < FeatureTest

  def test_user_sees_all_events
    aggregate_setup

    visit('/sources/jumpstartlab/events')

    assert page.has_content?("Jumpstartlab's Events")
    assert page.has_content?("Event_most")
    click_link("Event_most")
    assert_equal '/sources/jumpstartlab/events/event_most', current_path
  end

end
