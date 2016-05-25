require_relative '../test_helper'

class ClientCanNavigateToEventsWhenEventNotFoundTest < FeatureTest

  def test_user_can_navigate_to_real_events_when_event_not_found
    aggregate_setup

    visit('/sources/jumpstartlab/events/MISSING_EVENT')

    click_link("See List of Events")
    assert_equal '/sources/jumpstartlab/events', current_path
    assert page.has_content?("Event_most")
    assert page.has_content?("Event_least")

  end
end
