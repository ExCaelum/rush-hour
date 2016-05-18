class Url < ActiveRecord::Base
  validates :address, presence: true
  has_many :payload_requests

  def self.max_response
    PayloadRequest.maximum(:responded_in)
  end
  
  def self.min_response
    PayloadRequest.minimum(:responded_in)
  end
  
  def self.average_response
    PayloadRequest.average(:responded_in)
  end
  
end
