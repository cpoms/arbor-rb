require 'arbor/utils'

module Arbor
  module API
    include Arbor::Utils

    def retrieve(type, id)
      resource = parse_resource(type)
      get("/#{resource}/#{id}")
    end

    def query(type, query = nil)
      resource = parse_resource(type)
      query_string = query.build_query_string if query

      get("/#{resource}?#{query_string}")
    end
  end
end
