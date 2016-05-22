module RushHour
  class Server < Sinatra::Base

    post '/sources' do
      client = Client.new({identifier: params["identifier"],
                           root_url: params["rootUrl"]})

      name = params[:identifier]
      if Client.find_by(identifier: params['identifier'])
        status 403
        body "Client with #{name.upcase} identifier is already registered."
      elsif client.save
        status 200
        body "{\"Identifier\": #{name}}"
      else
        status 400
        body "#{client.errors.full_messages.join(", ")}"
      end

    end

    post '/sources/:identifier/data' do |identifier|
      payload = params[:payload]
      if params.empty? || !params.key?('payload') ||(payload && payload.empty?)
        status 400
        body "Payload data was not provided."
      elsif PayloadRequest.duplicate?(params[:payload], identifier)
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

    get '/sources/:identifier/events' do |identifier|
      @identifier = identifier
      @events = Client.find_by(identifier: identifier).event_names
      erb :event_index

    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      client = Client.find_by(identifier: identifier)

      event = client.event_names.find_by(name: event_name)

      pass unless event

      @event_name = event.name

      @count_by_hour = client.event_requests_by_hour(event_name)

      erb :event_show
    end

    get '/sources/:identifier/events/*' do |identifier, splat|
      @identifier = identifier
      @bad_event_name = params[:splat].first
      erb :event_not_found
    end

    get '/sources/:identifier' do |identifier|
      client = Client.find_by(identifier: identifier)
      if Client.identifier_exists?(identifier)
        if client.payload_requests.count > 0
          @client = client
          erb :dashboard
        else
          @client = client
          erb :no_payload
        end
      else #no client
        erb :error
      end
    end

    get '/sources/:identifier/urls/:relative_path' do |identifier, rel_path|
      client = Client.find_by(identifier: identifier)
      if client.relative_path_exists?(rel_path)
        @url = client.find_url_by_relative_path(rel_path)
        erb :url_dashboard
      else
        @path = rel_path
        erb :url_error
      end
    end

  end
end
