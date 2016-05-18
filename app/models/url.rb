class Url < ActiveRecord::Base
  validates :address, presence: true

  has_many :payload_requests


  def self.most_to_least_requested
    ordered_hash = PayloadRequest.group(:url).order('count_all desc').count
    ordered_hash.keys.map {|url_obj| url_obj[:address]}

  end
end
