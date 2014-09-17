require 'arbor/model/factory'

module Arbor
  module Model
    class Serialiser
      class << self
        def deserialise(data)
          attributes = parse_attributes(data)

          resource = data["entityType"].underscore.to_sym
          Factory.create(resource).new(attributes)
        end

        def parse_attributes(attributes)
          attr_array = attributes.map do |key, value|
            value = case value
              when Hash
                parse_resource(value)
              when Array
                value.map { |nr| parse_resource(nr) }
              else
                value
              end
            [key, value]
          end

          transform_keys(Hash[attr_array])
        end

        def parse_resource(r)
          nested_type = r["entityType"]
          nested_type ? Arbor.serialisers[nested_type].deserialise(r) : r
        end

        def transform_keys(hash)
          Hash[hash.map { |k, v| [k.underscore, v] }]
        end
      end
    end
  end
end