module ValidatePayload

  def get_response(request, payload, client)
    if #some type of record conditional
			[403, "#{client.identifier}: This request has already been created."]
		elsif request.save
			[200, "Payload Request Created"]
		elsif payload.values.include?(nil)
			[400, request.errors.full_messages.join("")]
		else
			[418, "Goodluck"]
		end
  end
end
