class RushHourApp < Sinatra::Base

  post '/sources' do
    client = Client.new({identifier: params["identifier"], root_url: params["rootUrl"]})

    if Client.find_by(identifier: params['identifier'])
      status 403
      body "Client with this identifier is already registered."
    elsif client.save
      status 200
      body "{\"Identifier\": #{params[:identifier]}}"
    else
      status 400
      body "#{client.errors.full_messages.join(", ")}"
    end

  end

  end
