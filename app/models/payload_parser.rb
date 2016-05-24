require 'json'
require 'pry'
# responsible for converting JSON to a clean hash, and generating SHA-1 hashes
module PayloadParser

  def self.parse_json(params)
    raw_payload = JSON.parse(params)
    new_user_agent = UserAgentParser.parse(raw_payload["userAgent"])
    result = { requested_at: raw_payload["requestedAt"],
               responded_in: raw_payload["respondedIn"],
               parameters: raw_payload["parameters"],
               referrer: { address: raw_payload["referredBy"] },
               request_type: { verb: raw_payload["requestType"] },
               event_name: { name: raw_payload["eventName"] },
               resolution: { width: raw_payload["resolutionWidth"],
                             height: raw_payload["resolutionHeight"] },
               user_agent: { os: new_user_agent.os.to_s,
                             browser: new_user_agent.to_s },
               ip: { address: raw_payload["ip"] },
               url: { address: raw_payload["url"] } }
  end

  def self.generate_sha(payload)
    Digest::SHA1.hexdigest(payload.to_s)
  end
end

