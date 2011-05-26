module Rack
  module If
    class Server

      attr_reader :app, :env

      def initialize(app, options={}, &block)
        @options     = options
        @app         = app

        @middleware = []
        @block = block
      end

      # shortcuts
      def path                 ; env["PATH_INFO"]            ; end
      def method               ; env["REQUEST_METHOD"]       ; end
      def user_agent           ; env["HTTP_USER_AGENT"]      ; end
      def host                 ; env["HTTP_HOST"]            ; end
      def port                 ; env["SERVER_PORT"]          ; end
      def query_string         ; env["QUERY_STRING"]         ; end
      def http_accept          ; env["HTTP_ACCEPT"]          ; end
      def http_accept_encoding ; env["HTTP_ACCEPT_ENCODING"] ; end

      def call(rack_environment)
        @env = rack_environment
        instance_eval(&@block)
        if @middleware.any?
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
  end
end