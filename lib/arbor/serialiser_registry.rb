require 'arbor/model/serialiser'

module Arbor
  class SerialiserRegistry
    attr_accessor :registry, :default_serialiser

    def initialize
      @registry = {}
      @default_serialiser = Model::Serialiser
    end

    def register(resource, serialiser)
      registry[resource] = serialiser
    end

    def unregister(resource)
      registry[resource] = nil
    end

    def get_serialiser(resource)
      registry[resource] || default_serialiser
    end
    alias_method :[], :get_serialiser
  end
end