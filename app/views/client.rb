class Client < ActiveRecord::Base
  validates :root_url, presence: true
  validates :identifier, presence: true, uniqueness: true

  has_many :payload_requests
  has_many :resolutions, through: :payload_requests
  has_many :event_names, through: :payload_requests
  has_many :ips, through: :payload_requests
  has_many :referrers, through: :payload_requests
  has_many :request_types, through: :payload_requests
  has_many :urls, through: :payload_requests
  has_many :user_agents, through: :payload_requests

  def self.identifier_exists?(identifier)
    Client.find_by(identifier: identifier)
  end

  def event_requests_by_hour(event_name)
    payload_requests.joins(:event_name).
    where("event_names.name='#{event_name}'").
    group("date_part('hour', requested_at AT TIME ZONE 'GMT-7')").count
  end





end
