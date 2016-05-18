class UpdateResolutionsInPr < ActiveRecord::Migration
  def change
    remove_column :payload_requests, :resolution_width
    remove_column :payload_requests, :resolution_height
    add_reference :payload_requests, :resolution, index: true
  end
end
