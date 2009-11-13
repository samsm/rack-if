require 'rubygems'
require 'rack'
require 'ruby-debug'

class Rack::Nest

  def initialize(app,options ={}, block = lambda {})
    @path = options[:path]
    @method = options[:method]
    @app = app
    @block = block
  end

  def call(env)
    if @path == env['PATH_INFO']
      child_app = @app
      block = @block
      new_app = Rack::Builder.app do
        # This works:
        # use Rack::Auth::Basic, "Lobster 2.0" do |username, password|
        #   'secret' == password
        # end
        
        # This doesn't:
        block.call
        
        
        run lambda { |env| child_app.call(env) }
      end
      new_app.call(env)
    else
      @app.call(env)
    end
  end
end

use Rack::Nest, {:path => '/no'} do
  use Rack::Auth::Basic, "Lobster 2.0" do |username, password|
    'secret' == password
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Hi'] }