module Arbor
  module Utils
    def parse_resource(type)
      validate(get_resource(type), Arbor::RESOURCES)
    end

    def get_resource(type)
      case type
      when Class
        type.name.pluralize.underscore.to_sym
      when String
        type.pluralize.to_sym
      when Symbol
        type.to_s.pluralize.to_sym
      else
        raise ArgumentError, "must supply a Class, String or Symbol for type"
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
