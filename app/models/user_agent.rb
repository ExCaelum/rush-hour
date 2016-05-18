class UserAgent < ActiveRecord::Base
  validates :browser, presence: true
  validates :os, presence: true

  has_many :payload_requests
  has_many :clients, through: :payload_requests
end
