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
end
