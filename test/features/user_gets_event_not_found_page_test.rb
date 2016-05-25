require_relative '../test_helper'

class ClientGetsEventNotFoundTest < FeatureTest

  def test_user_sees_not_found_page_when_no_event_for_client
    aggregate_setup

    visit('/sources/jumpstartlab/events/MISSING_EVENT')

    assert page.has_content?("MISSING_EVENT was not found for Jumpstartlab.")
  end

end
