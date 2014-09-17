require 'active_support/core_ext/string'

module Arbor
  module Utils
    def parse_resource(type)
      validate(get_resource(type), Arbor::RESOURCES)
    end

    def get_resource(type)
      case type
      when Class
        type.name.pluralize.underscore.to_sym
      else
        type.to_s.pluralize.to_sym
      end
    end

    def validate(choice, options)
      unless options.include?(choice)
        raise ArgumentError, "#{choice} is not a valid option: #{options}"
      end
      choice
    end

    def left_pad(array, num)
      num.times { array.unshift(nil) }
    end
  end
end
