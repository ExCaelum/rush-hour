module PayloadCreator
  def self.record_payload(raw_json, client_identifier)
    payload = PayloadParser.parse_json(raw_json)
    client = Client.find_by(identifier: client_identifier)
    inclusive_payload = payload
    inclusive_payload[:client] = client

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
    pr.client = client
    pr.parameters = payload[:parameters]
    pr.key = PayloadParser.generate_sha(inclusive_payload)
    pr.save
  end
end
