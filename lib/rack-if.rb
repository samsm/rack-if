require "#{File.dirname(__FILE__)}/rack-if/server"

module Rack
  module If
    def self.new(*args, &blk)
      lambda { |env| Server.new(*args, &blk).call(env) }
    end
  end
end
