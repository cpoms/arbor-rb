require 'arbor/api'
require 'arbor/utils'
require 'httpi'
require 'json'

module Arbor
  class Client
    include Arbor::API
    include Arbor::Utils
    attr_accessor :host, :username, :password, :settings

    def initialize(*args)
      @settings = args.last.is_a?(Hash) ? args.pop : {}
      raise ArgumentError, "must supply a subdomain, username and password" if args.length < 3
      subdomain, @username, @password = args
      @host = "https://#{subdomain}.uk.arbor.sc"
    end

    [:get, :post].each do |verb|
      define_method(verb) do |*args|
        request = configure_request(*args)
        response = attempt((settings[:retries] || 1).times) do
          HTTPI.request(verb, request, settings[:adapter])
        end
        JSON.parse(response.body.presence || "{}")
      end
    end

    private
      def configure_request(path, *args)
        url = "#{host}#{path}"
        request = HTTPI::Request.new(url, *args)
        request.headers["Accept"] = "application/json"
        auth_type = settings[:adapter] == :net_http ? :basic : :digest
        request.auth.send(auth_type, username, password)
        request
      end
  end
end
