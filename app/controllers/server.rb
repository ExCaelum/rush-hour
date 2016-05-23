module RushHour
  class Server < Sinatra::Base

    post '/sources' do
      client = Client.new({identifier: params["identifier"],
                           root_url: params["rootUrl"]})
      name   = params[:identifier]
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
      @error_message = "#{splat} was not found for #{identifier.capitalize}."
      @body = "<a href='/sources/#{identifier}/events'>See List of Events</a>"
      erb :error
    end

    get '/sources/:identifier/urls/:rel_path' do |identifier, rel_path|
      client = Client.find_by(identifier: identifier)
      @url = client.find_url_by_relative_path(rel_path)
      pass unless @url
      erb :url_dashboard
    end

    get '/sources/:identifier/urls/*' do |identifier, splat|
      @error_message = "No Data for #{splat} for #{identifier.capitalize}"
      erb :error
    end

    get '/sources/:identifier' do |identifier|
      @client = Client.find_by(identifier: identifier)
      pass unless @client
      payload_requests = @client.payload_requests
      pass if payload_requests.empty?
      erb :dashboard
    end


    get '/sources/*' do |splat|
      if !Client.find_by(identifier: splat)
        @error_message = "#{splat.capitalize} does not exist"
      else
        @error_message = "There is no payload data for:
        #{splat.capitalize}"
      end
      erb :error
    end

  end
end
