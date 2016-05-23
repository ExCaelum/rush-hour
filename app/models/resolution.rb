# class interacts with the Resolution table
class Resolution < ActiveRecord::Base
  validates :height, presence: true
  validates :width, presence: true

  has_many :payload_requests
  has_many :clients, through: :payload_requests

  def self.list_of_resolutions
    id_list = PayloadRequest.distinct.pluck(:resolution_id)
    id_list.map do |id|
      "#{Resolution.find(id).height} x #{Resolution.find(id).width}"
    end
  end

end
