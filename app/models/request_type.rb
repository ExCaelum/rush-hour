class RequestType < ActiveRecord::Base
  validates :verb, presence: true

  has_many :payload_requests

  def self.most_frequent_request_type
    request_frequency = PayloadRequest.group(:request_type).order("count_all desc").count
    request_frequency.max_by { |k,v,| v }.first
    #works, could be better
  end

  def self.all_http_verbs
    request_type_id = PayloadRequest.distinct.pluck(:request_type_id)
    request_type_id.map do |id|
      RequestType.find(id).verb
    end
  end

end
