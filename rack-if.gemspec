# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack-if/version"

Gem::Specification.new do |s|
  s.name        = "rack-if"
  s.version     = Rack::If::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sam Schenkman-Moore"]
  s.email       = ["samsm@samsm.com"]
  s.homepage    = "http://github.com/samsm/rack-if"
  s.summary     = %q{Conditional use of rack apps.}
  s.description = %q{Use or don't use Rack apps based on a variety of environment factors.}

  s.rubyforge_project = "rack-if"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rack', ['> 1']
end
