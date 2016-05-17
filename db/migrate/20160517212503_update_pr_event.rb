class UpdatePrEvent < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :event_name
    add_reference :payload_requests, :event_name, index: true
  end
end
