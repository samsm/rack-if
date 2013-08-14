require_relative "helper"
require 'rack/request'
require 'rack/lint'

class TestRackIf < Test::Unit::TestCase

  class BadMethodMiddleWare
    def initialize(*args) ; end
    def call(env)
      [405, {'Content-Type' => 'text/plain'}, 'That method wasn\'t allowed.']
    end
  end

  def setup
    app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Hi'] }
    @if = Rack::If.new(app) do
      if method != 'GET'
        use BadMethodMiddleWare
      end
    end
  end

  def mock_request(options = {})
    {
      "HTTP_CACHE_CONTROL"=>"max-age=0",
      "HTTP_HOST"=>"localhost:9292",
      "HTTP_ACCEPT"=>"application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5",
      "SERVER_NAME"=>"localhost",
      "REQUEST_PATH"=>"/protected",
      "rack.url_scheme"=>"http",
      "HTTP_USER_AGENT"=>"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_7; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1",
      "REMOTE_HOST"=>"localhost",
      "HTTP_ACCEPT_LANGUAGE"=>"en-us",
      "SERVER_PROTOCOL"=>"HTTP/1.1",
      "rack.input"=>Rack::Lint::InputWrapper.new('test'),
      "rack.version"=>[1, 1],
      "rack.run_once"=>false,
      "SERVER_SOFTWARE"=>"WEBrick/1.3.1 (Ruby/1.8.7/2010-08-16)",
      "REMOTE_ADDR"=>"127.0.0.1",
      "PATH_INFO"=>"/protected",
      "HTTP_AUTHORIZATION"=>"Basic OnNlY3JldA==",
      "SCRIPT_NAME"=>"",
      "HTTP_VERSION"=>"HTTP/1.1",
      "rack.multithread"=>true,
      "rack.multiprocess"=>false,
      "REQUEST_URI"=>"http://localhost:9292/protected",
      "SERVER_PORT"=>"9292",
      "REQUEST_METHOD"=>"GET",
      "HTTP_ACCEPT_ENCODING"=>"gzip, deflate",
      "HTTP_CONNECTION"=>"keep-alive",
      "QUERY_STRING"=>"",
      "GATEWAY_INTERFACE"=>"CGI/1.1"
    }.merge(options)
  end

  def test_pass_through_when_no_middleware_added
    assert_equal 200, @if.call(mock_request({'REQUEST_METHOD' => 'GET'})).first
  end

  def test_use_middleware_when_conditions_add_it
    assert_equal 405, @if.call(mock_request({'REQUEST_METHOD' => 'PUT'})).first
  end
end
