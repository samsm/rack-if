require 'rubygems'
require 'rack'
require 'ruby-debug'
 
class Rack::If
 
  attr_reader :app
 
  def initialize(app, options={}, &block)
    @options = options
    @app     = app
    
    @middleware = []
    instance_eval(&block)
  end
  
  def match?(env)
    @options.inject(true) do |memo, pair|
      if_key = pair[0]
      rack_key = comparison_table[if_key]
      if_value = pair[1]
      if if_value.kind_of? Regexp
        memo && env[rack_key] =~ if_value
      else
        memo && env[rack_key] == if_value
      end
    end
  end
  
  def comparison_table
    {
      :path => "PATH_INFO",
      :method => "REQUEST_METHOD",
      :user_agent => "HTTP_USER_AGENT",
      :host => "HTTP_HOST",
      :port => "SERVER_PORT",
      :query_string => "SERVER_PORT",
      :http_accept =>  "HTTP_ACCEPT",
      :http_accept_encoding => "HTTP_ACCEPT_ENCODING"
    }
  end
  
  def call(env)
    if match?(env)
      stack.call(env)
    else
      app.call(env)
    end
  end
 
  def stack
    @middleware.reverse.inject(app) { |app, mid| mid.call(app) }
  end
 
  def use(middleware, *args, &block)
    @middleware << lambda { |app| middleware.new(app, *args, &block) }
  end
  
end
 
use Rack::If, :path => '/no' do
  use Rack::Auth::Basic, "Rif" do |username, password|
    'secret' == password
  end
end
 
run lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Hi'] }
