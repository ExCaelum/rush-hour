class Url < ActiveRecord::Base
  validates :address, presence: true

  has_many :payload_requests
  has_many :clients, through: :payload_requests

  def self.most_to_least_requested
    ordered_hash = PayloadRequest.group(:url).order('count_all desc').count
    ordered_hash.keys.map {|url_obj| url_obj[:address]}
  end

  def list_response_times
    payload_requests.pluck(:responded_in)
  end

  def top_three_referrers
    top_referrer_ids = payload_requests.group(:referrer_id).
                       order('count_all desc').count.keys.take(3)
    top_referrer_ids.map {|ref_id| Referrer.find(ref_id).address}

  end

  def http_verbs
    request_type_id = payload_requests.pluck(:request_type_id)
    request_type_id.map do |id|
      RequestType.find(id).verb
    end.uniq
  end

  def popular_agents
    top_user_agents = payload_requests.group(:user_agent_id).
                      order('count_all desc').count.keys.take(3)

    top_user_agents.map do |id|
      agent = UserAgent.find(id)
      "#{agent.os} #{agent.browser}"
    end
  end

  def max_response_for_url
    payload_requests.maximum(:responded_in)
  end

  def min_response_for_url
    payload_requests.minimum(:responded_in)
  end

  def average_response_for_url
    payload_requests.average(:responded_in).round(2)
  end

  def response_times_order
    list_response_times.sort.reverse
  end

end
