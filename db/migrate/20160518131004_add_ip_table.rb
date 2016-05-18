class AddIpTable < ActiveRecord::Migration
  def change
    create_table :ips do |t|
      t.string :address, unique: true
      t.timestamps null: false
    end
    remove_column :payload_requests, :ip, :string
    add_reference :payload_requests, :ip, index: true
  end

    # migrate data to new table
    # PayloadRequest.all.each do |payload_request|
    #  payload_request.update_attributes!(ip_id: Ip.find_or_create_by(address: address).pluck(:id))
    # end

end
