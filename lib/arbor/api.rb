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

      data = get("/rest-v2/#{resource.dasherize.tr('/', '_')}?#{query_string}")

      unmarshall_data(data, resource)
    end

    def changelog(type, from_revision = 0)
      resource = parse_resource_name(type)

      data = get("/rest-v2/#{resource.dasherize.tr('/', '_')}/changelog?from-revision=#{from_revision}")

      data['changes'].each do |c|
        c['entityType'] = "change"
        @highest_revision = [highest_revision, BigDecimal.new(c['toRevision'])].max
      end

      unmarshall_data(data, 'changes')
    end

    private
      def unmarshall_data(data, resource)
        singular_resource = resource.singularize.camelize(:lower).gsub('::', '_')
        plural_resource   = resource.camelize(:lower).gsub('::', '_')

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
        elsif data["errors"] || (data["status"] && !data["status"]["success"])
          raise Errors::APIError, "#{data["status"]["code"]} #{data["status"]["reason"]}: #{data["status"]["errors"].join(", ")}"
        elsif (data[:response] && !data["response"]["success"])
          raise Errors::APIError, "#{data["response"]["code"]} #{data["response"]["reason"]}"
        else
          raise Errors::SerialisationError, "Unexpected root key in API data. Expected: #{plural_resource} or #{singular_resource}. Actual data: #{data}"
        end
      end
  end
end
