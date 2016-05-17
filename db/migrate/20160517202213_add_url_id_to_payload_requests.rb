class AddUrlIdToPayloadRequests < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :url
    add_reference :payload_requests, :url, index: true
  end
end
