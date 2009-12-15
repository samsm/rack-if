require File.dirname(__FILE__) + '/if'

class Rack::If
 
  attr_reader :app
 
  def initialize(app, options={}, &block)
    @options     = options
    @app         = app
    
    @block = block
  end

  def call(rack_environment)
    Rack::IfProcessing.new(app,@options, &@block).call(rack_environment)
  end
  
end