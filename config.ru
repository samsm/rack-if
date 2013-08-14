require 'rubygems'
require 'rack'
require './lib/rack-if'

use Rack::If do
  if path == '/protected' && method == 'GET'
    use Rack::Auth::Basic, "Rack::If Example" do |username, password|
      'secret' == password
    end
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/html'}, ['Hi. Try /protected']] }
