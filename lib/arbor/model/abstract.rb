module Arbor
  module Model
    class Abstract
      attr_accessor :api_client, :entity_type, :attribute_names

      def initialize(attributes)
        @attribute_names = []
        load_attributes(attributes)
      end

      def method_missing(meth, *args, &block)
        refresh_data

        if respond_to?(meth)
          send(meth, *args, &block)
        else
          super
        end
      end

      def refresh_data
        raise "No API client configured for this resource" if api_client.nil?
        raise "No entity_type set for this resource" if entity_type.nil?
        raise "No known endpoint for this resource" if href.nil?

        data = api_client.get(href)

        parsed_attributes = Serialiser.parse_attributes(data[entity_type.downcase])
        load_attributes(parsed_attributes)
        attach_client(self.api_client)
      end

      def load_attributes(attributes)
        attributes.each do |name, value|
          unless self.respond_to?("#{name}=")
            self.class.send(:attr_accessor, name)
            @attribute_names << name
          end
          self.send("#{name}=", value)
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
    end
  end
end