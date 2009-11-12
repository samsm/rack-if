require 'rubygems'
require 'rack'
require 'pather'
require 'rack/builder'
require 'ruby-debug'

class Rack::Nest

  def initialize(app,options ={}, &block)
    @path = options[:path]
    @method = options[:method]
    @app = app
    @block = block
  end

  def call(env)
    if @path == env['PATH_INFO']
      child_app = @app
      new_app = Rack::Builder.app do
        use Rack::Auth::Basic, "Lobster 2.0" do |username, password|
          'secret' == password
        end
        run lambda { |env| child_app.call(env) }
      end
      new_app.call(env)
    else
      @app.call(env)
    end
  end
end

use Rack::Nest, :path => '/no'

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Hi'] }