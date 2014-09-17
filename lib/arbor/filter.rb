require 'arbor/utils'

module Arbor
  class Filter
    include Arbor::Utils
    attr_accessor :attribute, :operator, :value
    OPERATORS = [:equals, :from, :to, :after, :before, :search, :in]

    def initialize(attribute, operator, value)
      @attribute = attribute
      @operator = validate(operator, OPERATORS)
      @value = value
    end

    def to_s
      "filters.#{attribute}.#{operator}=#{value}"
    end
  end
end
