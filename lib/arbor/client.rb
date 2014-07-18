require 'arbor/api'
require 'arbor/utils'
require 'httpi'

module Arbor
  class Client
    include Arbor::API
    include Arbor::Utils
    attr_accessor :host, :username, :password, :settings
    DEFAULT_API_HOST = "http://trunk.staging.arbor.sc/rest-v2/"

    def initialize(*args)
      @settings = args.pop if args.last.is_a?(Hash)
      raise ArgumentError, "must supply a username and password" if args.length < 2
      @host, @username, @password = left_pad(args, 3)
      @host ||= DEFAULT_API_HOST
    end

    def get(*args)
      request = configure_request(*args)
      HTTPI.get(request, settings[:adapter])
    end

    def post(*args)
      request = configure_request(*args)
      HTTPI.post(request, settings[:adapter])
    end

    def configure_request(*args)
      request = HTTPI::Request.new(*args)
      request.auth.digest(username, password)
      request
    end
  end
end
