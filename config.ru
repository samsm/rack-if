require 'rubygems'
require 'rack'
require 'lib/rackif'

use Rack::If, {:path => '/protected', :method => 'GET'}, {:match => :any} do
  use Rack::Auth::Basic, "Rack::If Example" do |username, password|
    'secret' == password
  end
end

run lambda { |env| [200, {'Content-Type' => 'text/plain'}, 'Hi'] }
