# Rakefile
require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('rackif', '0.0.1') do |p|
  p.summary        = "Conditional use of rack apps"
  p.description    = "Use or don't use Rack apps based on a variety of environment factors."
  # p.url            = "http://samsm.com/"
  # p.author         = "Sam Schenkman-Moore"
  # p.email          = "samsm@samsm.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.runtime_dependencies = ['rack']
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
