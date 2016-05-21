module RushHour
  class Server < Sinatra::Base
    not_found do
      erb :error
    end

      post '/sources' do
        client = Client.new({identifier: params["identifier"], root_url: params["rootUrl"]})

        if Client.find_by(identifier: params['identifier'])
          status 403
          body "Client with #{params[:identifier].upcase} identifier is already registered."
        elsif client.save
          status 200
          body "{\"Identifier\": #{params[:identifier]}}"
        else
          status 400
          body "#{client.errors.full_messages.join(", ")}"
        end

      end

      post '/sources/:identifier/data' do |identifier|
        if params.empty? || !params.key?('payload') ||(params['payload'] && params['payload'].empty?)
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
        status 200
        last_response = "event listing for #{identifier}"
        erb :index
      end

      # get 'sources/*/events/*' do
      #   identifier = params[:splat].first
      #   event_name = params[:splat].last
      #   pass unless

      # get 'sources/:identifier/events/:event_name' do |identifier, event_name|
      #   @count_by_hour = Client.find_by(identifier: identifier).event_requests_by_hour
      #   erb :show
      # end
    end
end
