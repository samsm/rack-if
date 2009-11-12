class Rack::Pather
  def initialize(app, options={})
    @app = app
  end

  def call(env)
    @app.call(env) # pass through
  end
  
end