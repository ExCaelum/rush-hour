class CreateReferrers < ActiveRecord::Migration
  def change
    create_table :referrers do |t|
      t.string :address
      t.timestamps null: false
    end
  end

  add_reference :payload_requests, :referrer, index: true
  # migrate data to new table

  # PayloadRequest.all.each do |payload_request|
  #   payload_request.update_attributes!(referrer_id: Referrer.find_or_create_by(address: address).pluck(:id))
  # end

  remove_column :payload_requests, :referrered_by

end
