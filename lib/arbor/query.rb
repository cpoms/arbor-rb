require 'uri'
require 'arbor/utils'
require 'arbor/filter'

module Arbor
  class Query
    include Arbor::Utils

    attr_accessor :filters, :resource

    def initialize(type, filters = [])
      @resource = parse_resource(type)
      @filters = filters
    end

    def build_query_string
      URI.escape(filters.map(&:to_s).join("&"))
    end

    def add_filter(*args)
      @filters << Arbor::Filter.new(*args)
    end
  end
end
