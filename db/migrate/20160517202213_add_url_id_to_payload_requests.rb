class AddUrlIdToPayloadRequests < ActiveRecord::Migration
  def change
    add_reference :payload_requests, :url, index: true
    remove_column :payload_requests, :url
  end
end
