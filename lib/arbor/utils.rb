require 'active_support/core_ext/string'

module Arbor
  module Utils
    INFLECTIONS = { 'person' => 'persons' }

    def parse_resource_name(type)
      validate(get_resource_name(type), Arbor::RESOURCES)
    end

    def get_resource_name(type)
      case type
      when Class
        # do reverse serialiser lookup instead
        pluralize(type.name).underscore
      else
        pluralize(type.to_s)
      end
    end

    def validate(choice, options)
      unless options.include?(choice.to_sym)
        raise ArgumentError, "#{choice} is not a valid option: #{options}"
      end
      choice
    end

    def left_pad(array, num)
      num.times { array.unshift(nil) }
    end

    def attempt(enum)
      exception = nil
      enum.each do
        begin
          return yield
        rescue => e
          exception = e
          next
        end
      end
      raise exception
    end

    private
      def pluralize(string)
        INFLECTIONS[string] || string.pluralize
      end
  end
end
