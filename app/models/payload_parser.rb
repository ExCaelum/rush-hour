require 'json'
require 'pry'
module PayloadParser

	def self.parse_json(params)
    raw_payload = JSON.parse(params)
    new_user_agent = UserAgentParser.parse(raw_payload["userAgent"])
    result = {}
    result[:requested_at] = raw_payload["requestedAt"]
    result[:responded_in] = raw_payload["respondedIn"]
    result[:referrer] = { address: raw_payload["referredBy"] }
    result[:request_type] = { verb: raw_payload["requestType"] }
    result[:event_name] = { name: raw_payload["eventName"] }
    result[:resolution] = { width: raw_payload["resolutionWidth"],
                            height: raw_payload["resolutionHeight"] }
    result[:user_agent] = { os: new_user_agent.os.to_s, browser: new_user_agent.to_s }
    result[:ip] = { address: raw_payload["ip"] }
    result[:url] = { address: raw_payload["url"] }
		result
  end

	def self.generate_sha(payload)
    Digest::SHA1.hexdigest(payload.to_s)
  end

	# def initialize(params)
	# 	final_params = create_payload(params)
	# end
	#
	# def create_payload(params)
	# 	client = Client.find_by(identifier: params[:identifier])
	# 	raw_payload = JSON.parse(params[:payload])
	# 	payload = make_payload_request(raw_payload, client)
	# 	request = PayloadRequest.new(payload)
	# 	get_response(request, payload, client)
	# end
	#
  # def get_response(request, payload, client)
  #   if PayloadRequest.exists?(payload[:digest])
	# 		[403, "#{client.identifier}: This request has already been created."]
	# 	elsif request.save
	# 		[200, "Payload Request Created"]
	# 	elsif #check to see if payload is here
	# 		[400, request.errors.full_messages.join("")]
	# 	else
	# 		[418, "Goodluck"]
	# 	end
  # end
	#
	# def make_payload_request(raw_payload, client)
	# 	new_url = parse_url(raw_payload[:url])
	# 	new_referrer = parse_url(raw_payload[:referredBy])
	# 	new_user_agent = parse_user_agent(raw_payload[:userAgent])
	# 	payload = {
	# 		requested_at: raw_payload[:requestedAt],
	# 		responded_in: raw_payload[:respondedIn],
	# 		url_id: create_url(new_url[:url]).id,
	# 		request_type_id: create_request_type(raw_payload[:requestType]).id,
	# 		resolution_id: create_resolution(raw_payload[:resolutionWidth], raw_payload[:resolution_height]).id,
	# 		event_name_id: create_event_name(raw_payload[:eventName]).id,
	# 		user_agent_id: create_user_agent(new_user_agent.os, new_user_agent.browser).id,
	# 		referrer_id: create_referrer(new_referrer[:referredBy]).id,
	# 		ip_id: create_ip(raw_payload[:ip]).id,
	# 		client_id: client.id,
	# 		digest: Digest::SHA1.hexdigest(raw_payload.to_s)
	# 		}
	# 	payload
	# end
	#
	# def parse_user_agent(user_agent)
	# 	UserAgentParser(user_agent)
	# end
	#
	# def parse_url(url)
	# 	new_url = Hash.new
	# 	if url[0..6] == "http://"
	# 		url = url[7..-1]
	# 	elsif url[0..7] == "https://"
	# 		url = url[8..-1]
	# 	end
	# 	url = url.split("/")
	# 	new_url[:address].shift
	# 	new_url
	# end
	#
	# private
	#
	# def create_url(address)
	# 	Url.find_or_create_by(address: address)
	# end
	#
	# def create_request_type(request_type)
	# 	RequestType.find_or_create_by(verb: request_type)
	# end
	#
	# def create_resolution(width, height)
	# 	Resolution.find_or_create_by(width: width, height: height)
	# end
	#
	# def create_event_name(event_name)
	# 	EventName.find_or_create_by(name: event_name)
	# end
	#
	# def create_user_agent(os, browser)
	# 	UserAgent.find_or_create_by(os: os, browser: browser)
	# end
	#
	# def create_referrer(address)
	# 	Referrer.find_or_create_by(address: address)
	# end
	#
	# def create_ip(address)
	# 	Ip.find_or_create_by(address: address)
	# end
end
