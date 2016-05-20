class PayloadRequest < ActiveRecord::Base
  include PayloadParser

  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referrer_id, presence: true
  validates :event_name_id, presence: true
  validates :request_type_id, presence: true
  validates :resolution_id, presence: true
  validates :user_agent_id, presence: true
  validates :ip_id, presence: true
  # validates :client_id, presence: true

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

  def self.max_response
    PayloadRequest.maximum(:responded_in)
  end

  def self.min_response
    PayloadRequest.minimum(:responded_in)
  end

  def self.average_response
    PayloadRequest.average(:responded_in)
  end

  def self.duplicate?(payload, client_identifier)

  end

  def self.record_payload(raw_json, client_identifier)
    payload = PayloadParser.parse_json(raw_json)

    client = Client.find_by(identifier: client_identifier)

    pr = PayloadRequest.new
    pr.requested_at = payload[:requested_at]
    pr.responded_in = payload[:responded_in]
    pr.referrer = Referrer.find_or_create_by(payload[:referrer])
    pr.request_type = RequestType.find_or_create_by(payload[:request_type])
    pr.event_name = EventName.find_or_create_by(payload[:event_name])
    pr.resolution = Resolution.find_or_create_by(payload[:resolution])
    pr.user_agent = UserAgent.find_or_create_by(payload[:user_agent])
    pr.ip = Ip.find_or_create_by(payload[:ip])
    pr.url = Url.find_or_create_by(payload[:url])
    # Do something:
    pr.client = client
    pr.parameters = "[]"
    require "pry"; binding.pry
    pr.save

  end


end
