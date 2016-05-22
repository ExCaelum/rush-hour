require_relative '../test_helper'

class PayloadParserTest < Minitest::Test

  def test_convert_json_to_hash
    raw_json = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3b Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    result = JSON.parse(raw_json)
    expected = {"url"=>"http://jumpstartlab.com/blog",
                "requestedAt"=>"2013-02-16 21:38:28 -0700",
                "respondedIn"=>37,
                "referredBy"=>"http://jumpstartlab.com",
                "requestType"=>"GET",
                "parameters"=>[],
                "eventName"=>"socialLogin",
                "userAgent"=>"Mozilla/5.0 (Macintosh%3b Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                "resolutionWidth"=>"1920",
                "resolutionHeight"=>"1280",
                "ip"=>"63.29.38.211"}

    assert_equal expected, result
  end

  def test_we_can_parse_json
    raw_json = '{"url":"http://jumpstartlab.com/blog","requestedAt":"2013-02-16 21:38:28 -0700","respondedIn":37,"referredBy":"http://jumpstartlab.com","requestType":"GET","parameters":[],"eventName": "socialLogin","userAgent":"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17","resolutionWidth":"1920","resolutionHeight":"1280","ip":"63.29.38.211"}'
    result = PayloadParser.parse_json(raw_json)

    expected = {requested_at: "2013-02-16 21:38:28 -0700",
                responded_in: 37,
                    referrer: { address: "http://jumpstartlab.com" },
                request_type: { verb: "GET" },
                  event_name: { name: "socialLogin" },
                  resolution: { width: "1920", height: "1280" },
                  user_agent: { os: "Mac OS X 10.8.2", browser: "Chrome 24.0.1309" },
                          ip: { address: "63.29.38.211" },
                         url: { address: "http://jumpstartlab.com/blog"}}

    assert_equal expected[:requested_at], result[:requested_at]
    assert_equal expected[:responded_in], result[:responded_in]
    assert_equal expected[:referrer], result[:referrer]
    assert_equal expected[:request_type], result[:request_type]
    assert_equal expected[:event_name], result[:event_name]
    assert_equal expected[:resolution], result[:resolution]
    assert_equal expected[:user_agent], result[:user_agent]
    assert_equal expected[:ip], result[:ip]
    assert_equal expected[:url], result[:url]
  end
end
