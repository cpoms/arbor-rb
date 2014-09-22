require 'arbor/model/serialiser'

module Arbor
  module API
    def retrieve(type, id)
      resource = parse_resource_name(type)
      data = get("/rest-v2/#{resource.dasherize}/#{id}")

      unmarshall_data(data, resource)
    end

    def query(type, query = nil)
      resource = parse_resource_name(type)
      query_string = query.build_query_string if query

      data = get("/rest-v2/#{resource.dasherize}?#{query_string}")

      unmarshall_data(data, resource)
    end

    private
      def unmarshall_data(data, resource)
        singular_resource = resource.singularize.camelize(:lower)
        plural_resource   = resource.camelize(:lower)

        if (res = data[singular_resource])
          Model::Serialiser.parse_resource(res).tap { |obj|
            obj.attach_client(self) if obj.respond_to?(:attach_client)
            obj.lock_attributes = true if obj.respond_to?(:lock_attributes)
          }
        elsif data[plural_resource]
          data[plural_resource].map do |res|
            Model::Serialiser.parse_resource(res).tap { |obj|
              obj.attach_client(self) if obj.respond_to?(:attach_client)
            }
          end
        elsif data.empty?
          []
        elsif data["errors"]
          raise Errors::APIError, "#{data["status"]["code"]} #{data["status"]["reason"]}: #{data["status"]["errors"].join(", ")}"
        else
          raise Errors::SerialisationError, "Unexpected root key in API data. Expected: #{plural_resource} or #{singular_resource}. Actual: #{data.keys}"
        end
      end
  end
end
