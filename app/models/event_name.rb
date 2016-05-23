# class responsible for interating with EventName table
class EventName < ActiveRecord::Base
  validates :name, presence: true

  has_many :payload_requests
  has_many :clients, through: :payload_requests

  def self.most_to_least_received
    ordered_hash = PayloadRequest.group(:event_name).
                   order('count_all desc').count

    ordered_hash.keys.map {|event_obj| event_obj[:name]}
  end



end
