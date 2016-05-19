require 'json'
require 'pry'
class PayloadRequestCreator
  include ValidatePayload

	def initalize(params)
		final_params = create_payload(params)
		@status_code = final_params[0]
		@message = final_params[1]
	end

	def create_payload(params)
		client = Client.find_by(identifier: params[:identifier])
		raw_payload = JSON.parse(params[:payload])
		payload = make_payload_request(raw_payload, client)
		request = PayloadRequest.new(payload)
		get_response(request, payload, client)
	end

  def get_response(request, payload, client)
    if PayloadRequest.exists?(digest: payload[:digest])
			[403, "#{client.identifier}: This request has already been created."]
		elsif request.save
			[200, "Payload Request Created"]
		elsif payload.values.include?(nil)
			[400, request.errors.full_messages.join("")]
		else
			[418, "Goodluck"]
		end
  end

	def make_payload_request(raw_payload, client)
		new_url = parse_url(raw_payload[:url])
		new_referrer = parse_url(raw_payload[:referrer])
		new_user_agent = parse_user_agent(raw_payload[:user_agent])
		payload = {
			requested_at: raw_payload[:requested_at],
			responded_in: raw_payload[:responded_in],
			url_id: create_url(new_url[:address]).id,
			request_type_id: create_request_type(raw_payload[:request_type]).id,
			resolution_id: create_resolution(raw_payload[:resolution_width], raw_payload[:resolution_height]).id,
			event_name_id: create_event_name(raw_payload[:event_name]).id,
			user_agent_id: create_user_agent(new_user_agent.os, new_user_agent.browser).id,
			referrer_id: create_referrer(new_referrer[:address]).id,
			ip_id: create_ip(raw_payload[:address]).id,
			client_id: client.id,
      digest: Digest::SHA1.hexdigest(raw_payload.to_s)
			}
      binding.pry
		payload
	end

	def parse_user_agent(user_agent)
		UserAgentParser(user_agent)
	end

	def parse_url(url)
		new_url = Hash.new
		if url[0..6] == String.new("http://")
			url = url[7..-1]
		elsif url[0..7] == String.new("https://")
			url = url[8..-1]
		end
		url = url.split("/")
		new_url[:address].shift
		new_url
	end

	private

	def create_url(address)
		Url.find_or_create_by(address: address)
	end

	def create_request_type(request_type)
		RequestType.find_or_create_by(verb: request_type)
	end

	def create_resolution(width, height)
		Resolution.find_or_create_by(width: width, height: height)
	end

	def create_event_name(event_name)
		EventName.find_or_create_by(name: event_name)
	end

	def create_user_agent(os, browser)
		UserAgent.find_or_create_by(os: os, browser: browser)
	end

	def create_referrer(address)
		Referrer.find_or_create_by(address: address)
	end

	def create_ip(address)
		Ip.find_or_create_by(address: address)
	end
end

 params = 'payload={"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName":"socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
 prc = PayloadRequestCreator.new(params)
