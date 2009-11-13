require 'rubygems'
require 'rack'
require 'ruby-debug'
 
class Rack::Nest
 
  attr_reader :app
 
  def initialize(app, options={}, &block)
    @path   = options[:path]
    @method = options[:method]
    @app    = app
 
    @middleware = []
    instance_eval(&block)
  end
 
  def call(env)
    if @path == env['PATH_INFO']
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
 
use Rack::Nest, :path => '/no' do
  use Rack::Auth::Basic, "Lobster 2.0" do |username, password|
    'secret' == password
  end
end
 
run lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Hi'] }
