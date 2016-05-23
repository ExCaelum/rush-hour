# class is responsible for interacting with the Payload Request join table
class PayloadRequest < ActiveRecord::Base
  include PayloadParser

  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :parameters, presence: true
  validates :referrer_id, presence: true
  validates :event_name_id, presence: true
  validates :request_type_id, presence: true
  validates :resolution_id, presence: true
  validates :user_agent_id, presence: true
  validates :ip_id, presence: true
  validates :client_id, presence: true
  validates :key, presence: true

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
    parsed_payload = PayloadParser.parse_json(payload)
    parsed_payload[:client] = Client.find_by(identifier: client_identifier)
    key = PayloadParser.generate_sha(parsed_payload)
    PayloadRequest.find_by(key: key).is_a?(PayloadRequest)
  end

  def self.record_payload(raw_json, client_identifier)
    payload = PayloadParser.parse_json(raw_json)
    client = Client.find_by(identifier: client_identifier)
    payload[:client] = client

    pr = PayloadRequest.new
    pr.attributes =
      { requested_at:  payload[:requested_at],
        responded_in:  payload[:responded_in],
        referrer: Referrer.where(payload[:referrer]).first_or_create,
        request_type: RequestType.where(payload[:request_type]).first_or_create,
        event_name: EventName.where(payload[:event_name]).first_or_create,
        resolution: Resolution.where(payload[:resolution]).first_or_create,
        user_agent: UserAgent.where(payload[:user_agent]).first_or_create,
        ip: Ip.where(payload[:ip]).first_or_create,
        url: Url.where(payload[:url]).first_or_create,
        client: client,
        parameters: payload[:parameters],
        key: PayloadParser.generate_sha(payload) }
    pr.save
  end

end
