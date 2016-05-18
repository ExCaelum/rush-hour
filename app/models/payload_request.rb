class PayloadRequest < ActiveRecord::Base
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referrer_id, presence: true
  validates :event_name_id, presence: true
  validates :request_type_id, presence: true
  validates :resolution_id, presence: true
  validates :user_agent_id, presence: true
  validates :ip_id, presence: true

  belongs_to :url
  belongs_to :event_name
  belongs_to :request_type
  belongs_to :resolution
  belongs_to :user_agent
  belongs_to :referrer
  belongs_to :ip
  belongs_to :client

  def self.web_browser_breakdown
    user_agent_id = PayloadRequest.distinct.pluck(:user_agent_id)
    user_agent_id.map do |id|
      UserAgent.find(id).browser
    end
  end

  def self.os_breakdown
    user_agent_id = PayloadRequest.distinct.pluck(:user_agent_id)
    user_agent_id.map do |id|
      UserAgent.find(id).os
    end
  end
end
