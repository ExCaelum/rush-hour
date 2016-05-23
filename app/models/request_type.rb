# class interacts with request_types table
class RequestType < ActiveRecord::Base
  validates :verb, presence: true

  has_many :payload_requests
  has_many :clients, through: :payload_requests

  def self.most_frequent_request_type
    PayloadRequest.group(:request_type).
    order("count_all desc").count.keys.first
  end

  def self.all_http_verbs
    request_type_id = PayloadRequest.distinct.pluck(:request_type_id)
    request_type_id.map do |id|
      RequestType.find(id).verb
    end
  end

end
