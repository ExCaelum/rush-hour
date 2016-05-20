module ClientHelper
  def generate_payload(payload = {requested_at: "2013-02-16 21:38:28 -0700",
                                  responded_in: 48,
                                      referrer: { address: "www.example.com" },
                                  request_type: { verb: "GET" },
                                    event_name: { name: "event" },
                                    resolution: { width: "1000", height: "1000" },
                                    user_agent: { os: "OS", browser: "Browser" },
                                            ip: { address: "100.00.00.00" },
                                           url: { address: "www.example.com" },
                                        client: { identifier: "BestBuy", root_url: "www.bestbuy.com" }})

      # pr.referrer.create(Referrer.where(payload[:referrer]).first_or_create)

      pr = PayloadRequest.new
      pr.requested_at = payload[:requested_at]
      pr.responded_in = payload[:responded_in]
      pr.referrer = Referrer.where(payload[:referrer]).first_or_create

      pr.request_type = RequestType.where(payload[:request_type]).first_or_create

      pr.event_name = EventName.where(payload[:event_name]).first_or_create

      pr.resolution = Resolution.find_or_create_by(payload[:resolution])
      pr.user_agent = UserAgent.find_or_create_by(payload[:user_agent])
      pr.ip = Ip.find_or_create_by(payload[:ip])
      pr.url = Url.find_or_create_by(payload[:url])
      pr.client = Client.find_or_create_by(payload[:client])
      pr.parameters = "[]"
      pr.save
    end

end


