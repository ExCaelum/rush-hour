class PayloadRequest < ActiveRecord::Base
  validates :url_id, presence: true
  validates :requested_at, presence: true
  validates :responded_in, presence: true
  validates :referrer_id, presence: true
  validates :request_type, presence: true
  validates :event_name, presence: true
  validates :user_agent, presence: true
  validates :resolution_width, presence: true
  validates :resolution_height, presence: true
  validates :ip_id, presence: true

  belongs_to :url
  belongs_to :referrer
  belongs_to :ip
  # accepts_nested_attributes_for :ip
end
