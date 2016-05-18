class AddUserAgentIdToPayloadRequests < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :user_agent
    add_reference :payload_requests, :user_agent, index: true
  end
end
