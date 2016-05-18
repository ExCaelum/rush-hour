class PayloadRequest < ActiveRecord::Base
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referred_by, presence: true
  validates :event_name_id, presence: true
  validates :request_type_id, presence: true
  validates :user_agent, presence: true
  validates :resolution_id, presence: true
  validates :ip, presence: true

  belongs_to :url
  belongs_to :event_name
  belongs_to :request_type
  belongs_to :resolution


  #here or in URL???
  def self.list_response_times_for_url(url_id)
    Url.find(url_id).payload_requests.pluck(:responded_in)
  end

  #here or in URL???
  #tested it with event name instead bc didnt have referrer yet/passed
  #doesn't handle ties for third in any manner
  def self.top_three_referrers_for_url(url_id)
    top_referrer_ids = Url.find(url_id).payload_requests.group(:referrer_id).
                       order('count_all desc').count.keys.take(3)
    top_referrer_ids.map {|ref_id| Referrer.find(ref_id).name}

  end


end
