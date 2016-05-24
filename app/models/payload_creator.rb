module PayloadCreator

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
