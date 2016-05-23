require 'json'
require 'pry'
module PayloadParser

  def self.parse_json(params)
    raw_payload = JSON.parse(params)
    new_user_agent = UserAgentParser.parse(raw_payload["userAgent"])
    result = {}
    result[:requested_at] = raw_payload["requestedAt"]
    result[:responded_in] = raw_payload["respondedIn"]
    result[:parameters] = raw_payload["parameters"]
    result[:referrer] = { address: raw_payload["referredBy"] }
    result[:request_type] = { verb: raw_payload["requestType"] }
    result[:event_name] = { name: raw_payload["eventName"] }
    result[:resolution] = { width: raw_payload["resolutionWidth"],
                            height: raw_payload["resolutionHeight"] }
    result[:user_agent] = { os: new_user_agent.os.to_s,
                            browser: new_user_agent.to_s }
    result[:ip] = { address: raw_payload["ip"] }
    result[:url] = { address: raw_payload["url"] }
    result
  end

  def self.generate_sha(payload)
    Digest::SHA1.hexdigest(payload.to_s)
  end

  def self.get_response(name, client, params)
    if Client.find_by(identifier: params['identifier'])
      [403, "Client with #{name.upcase} identifier is already registered."]
    elsif client.save
      [200, "{\"Identifier\": #{name}}"]
    else
      [400, "#{client.errors.full_messages.join(", ")}"]
    end
  end

  def self.get_client_response
    if params.empty?|| !params.key?('payload')|| (payload && payload.empty?)
      status 400
      body "Payload data was not provided."
    elsif PayloadRequest.duplicate?(params[:payload], identifier)
      status 403
      body "This payload was already received."
    elsif !Client.identifier_exists?(identifier)
      status 403
      body "#{identifier} is not a registered application."
    elsif PayloadRequest.record_payload(params[:payload], identifier)
      status 200
    else
      status 418
      body "Bad Data"
    end
  end

end
