class RushHourApp < Sinatra::Base

  post '/sources' do
    client = Client.new({identifier: params["identifier"], root_url: params["rootUrl"]})

    if Client.find_by(identifier: params['identifier'])
      status 403
      body "Client with this identifier is already registered." #add interpolation
    elsif client.save
      status 200
      body "{\"Identifier\": #{params[:identifier]}}"
    else
      status 400
      body "#{client.errors.full_messages.join(", ")}"
    end

  end

  post '/sources/:identifier/data' do |identifier|
    if params.empty? || params[:payload].empty?
      status 403
      body "Payload data was not provided."
    elsif PayloadRequest.duplicate?(params[:payload])
      status 403
      body "This payload was already received."
    elsif !Client.identifier_exists?(identifier)
      status 403
      body "#{identifier} is not a registered application."
    else
      PayloadRequest.record_payload(params[:payload], identifier)
      status 200
    end
  end
