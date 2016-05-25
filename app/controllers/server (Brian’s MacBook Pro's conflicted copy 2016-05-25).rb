module RushHour
  class Server < Sinatra::Base

    post '/sources' do
      client = Client.new({identifier: params["identifier"],
                           root_url: params["rootUrl"]})

      response = Response.get_response(client, params)
      status response[0]
      body response[1]
    end

    post '/sources/:identifier/data' do |identifier|
      response = Response.get_client_response(identifier, params)
      status response[0]
      body response[1]
    end

    get '/sources/:identifier/events' do |identifier|
      identifier = identifier
      events = Client.find_by(identifier: identifier).event_names
      erb :event_index, locals: { identifier: identifier, events: events }
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      client = Client.find_by(identifier: identifier)
      event = client.event_names.find_by(name: event_name)
      pass unless event
      event_name = event.name
      count_by_hour = client.event_requests_by_hour(event_name)
      erb :event_show, locals: { event_name: event_name,
                                 count_by_hour: count_by_hour }
    end

    get '/sources/:identifier/events/*' do |identifier, splat|
      error_message = "#{splat} was not found for #{identifier.capitalize}."
      body = "<a href='/sources/#{identifier}/events'>See List of Events</a>"
      erb :error, locals: { error_message: error_message, body: body }
    end

    get '/sources/:identifier/urls/:rel_path' do |identifier, rel_path|
      client = Client.find_by(identifier: identifier)
      url = client.find_url_by_relative_path(rel_path)
      pass unless url
      erb :url_dashboard, locals: { url: url }
    end

    get '/sources/:identifier/urls/*' do |identifier, splat|
      error_message = "No Data for #{splat} for #{identifier.capitalize}"
      erb :error, locals: { error_message: error_message }
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
        error_message = "#{splat.capitalize} does not exist"
      else
        error_message = "There is no payload data for:
        #{splat.capitalize}"
      end
      erb :error, locals: { error_message: error_message }
    end

  end
end
