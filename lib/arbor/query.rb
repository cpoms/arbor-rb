require 'uri'
require 'arbor/filter'

module Arbor
  class Query
    attr_accessor :filters, :resource

    def initialize(filters = [])
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
