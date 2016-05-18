class RequestType < ActiveRecord::Base
  validates :verb, presence: true

  has_many :payload_requests

  def self.most_frequent_request_type
    request_frequency = joins(:payload_requests).group(:verb).order("count_all desc")
    request_frequency.max_by { |k,v,| v }.first
  end

end
