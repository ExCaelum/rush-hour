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



  def self.list_response_times_for_url(url_id)
    Url.find(url_id).payload_requests.pluck(:responded_in)
  end


end
