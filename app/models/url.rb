class Url < ActiveRecord::Base
  validates :address, presence: true

  has_many :payload_requests

  def self.most_to_least_requested
    ordered_hash = PayloadRequest.group(:url).order('count_all desc').count
    ordered_hash.keys.map {|url_obj| url_obj[:address]}
  end

  def list_response_times
    payload_requests.pluck(:responded_in)
  end

  #tested it with event name instead bc didnt have referrer yet/passed
  #doesn't handle ties for third in any manner
  def top_three_referrers
    top_referrer_ids = payload_requests.group(:referrer_id).
                       order('count_all desc').count.keys.take(3)
    top_referrer_ids.map {|ref_id| Referrer.find(ref_id).name}

  end

  def http_verbs
    request_type_id = payload_requests.pluck(:request_type_id)
    request_type_id.map do |id|
      RequestType.find(id).verb
    end.uniq
  end

  def popular_agents
    top_user_agents = payload_requests.group(:user_agent_id).order('count_all desc').count.keys.take(3)
    top_user_agents.map do |id|
      "#{UserAgent.find(id).os} #{UserAgent.find(id).browser}"
    end
  end

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
