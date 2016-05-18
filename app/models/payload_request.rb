class PayloadRequest < ActiveRecord::Base
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referred_by, presence: true
  validates :event_name_id, presence: true
  validates :request_type_id, presence: true
  validates :resolution_id, presence: true
  validates :user_agent_id, presence: true
  validates :ip, presence: true

  belongs_to :url
  belongs_to :event_name
  belongs_to :request_type
  belongs_to :resolution
  belongs_to :user_agent

  def self.web_browser_breakdown
    joins(:user_agent).pluck(:browser).uniq
  end

  def self.os_breakdown
    joins(:user_agent).pluck(:os).uniq
  end
end
