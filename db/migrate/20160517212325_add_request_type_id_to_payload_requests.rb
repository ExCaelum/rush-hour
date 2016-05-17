class AddRequestTypeIdToPayloadRequests < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :request_type
    add_reference :payload_requests, :request_type, index: true
  end
end
