module Response

  def self.get_response(client, params)
    if Client.find_by(identifier: params['identifier'])
      [403, "Client with #{params[:identifier].upcase} identifier is already registered."]
    elsif client.save
      [200, "{\"Identifier\": #{params[:identifier]}}"]
    else
      [400, "#{client.errors.full_messages.join(", ")}"]
    end
  end

  def self.get_client_response(identifier, params)
    if params.empty?|| !params.key?('payload')|| (params[:payload] &&
                                                  params[:payload].empty?)
      [400, "Payload data was not provided."]
    elsif PayloadRequest.duplicate?(params[:payload], identifier)
      [403, "This payload was already received."]
    elsif !Client.identifier_exists?(identifier)
      [403, "#{identifier} is not a registered application."]
    elsif PayloadCreator.record_payload(params[:payload], identifier)
      [200]
    else
      [418, "Bad Data"]
    end
  end
end
