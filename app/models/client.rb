require 'pry'
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

  def average_response_time_for_client
    payload_requests.average(:responded_in)
  end

  def min_response_time_for_client
    payload_requests.minimum(:responded_in)
  end

  def max_response_time_for_client
    payload_requests.maximum(:responded_in)
  end

  def most_frequent_request_type_for_client
    request_types.group(:verb).order('count_all desc').count.keys.first
  end

  def all_http_verbs_for_client
    request_types.pluck('DISTINCT verb')
  end

  def browser_breakdown_for_client
    user_agents.group(:browser).order('count_all desc').count
  end

  def operating_system_breakdown_for_client
    user_agents.group(:os).order('count_all desc').count
  end

  def url_list_ordered_by_request_count
    urls.group(:address).order('count_all desc').count.keys
  end


  def all_screen_resolutions_for_client
    resolution_list = resolutions.pluck('DISTINCT width, height')
    resolution_list.map {|resolution| "#{resolution[0]} x #{resolution[1]}"}
  end

  def self.identifier_exists?(identifier)
    Client.find_by(identifier: identifier)
  end


  def find_url_by_relative_path(relative_path)
    full_path = root_url + "/" + relative_path
    urls.find_by(address: full_path)
  end

  def relative_path_exists?(relative_path)
    full_path = root_url + "/" + relative_path
    !urls.find_by(address: full_path).nil?
  end



end
