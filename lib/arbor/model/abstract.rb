require 'arbor/model/serialiser'

module Arbor
  module Model
    class Abstract
      attr_accessor :api_client, :entity_type, :attribute_names, :attribute_lock

      def initialize(attributes)
        @attribute_names = []
        load_attributes(attributes)
      end

      def method_missing(meth, *args, &block)
        attribute_lock ? super : begin
          refresh_data
          send(meth, *args, &block)
        end
      end

      def refresh_data
        raise "No API client configured for this resource" if api_client.nil?
        raise "No entity_type set for this resource" if entity_type.nil?
        raise "No known endpoint for this resource" if href.nil?

        data = api_client.get(href)

        entity_type_lower = entity_type.tr('_', '-').camelize(:lower).tr('-', '_')
        parsed_attributes = Serialiser.parse_attributes(data[entity_type_lower])
        load_attributes(parsed_attributes)
        attach_client(self.api_client)

        @attribute_lock = true
      end

      def load_attributes(attributes)
        attributes.each do |name, value|
          unless self.respond_to?("#{name}=")
            self.class.instance_eval { define_method(name) { attribute(name) } }
            self.class.send(:attr_writer, name)
          end
          @attribute_names |= [name]
          self.send("#{name}=", value)
        end
      end

      def attribute(name)
        if instance_variable_defined?("@#{name}")
          instance_variable_get("@#{name}")
        else
          raise Errors::UnknownAttributeError if attribute_lock
          refresh_data
          attribute(name)
        end
      end

      def attach_client(client)
        self.api_client = client
        self.attribute_names.each do |name|
          if send(name).respond_to?("api_client=")
            send(name).attach_client(client)
          end
        end
      end

      def unlock_attributes
        @attribute_lock = false
      end

      def attributes
        Hash[attribute_names.map { |a| [a, send(a)] }]
      end

      def inspect
        "#<#{self.class.name} #{attribute_names.map { |a| "#{a}: #{send(a).inspect}" }.join(', ')}>"
      end
    end
  end
end