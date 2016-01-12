require 'arbor/model/abstract'

module Arbor
  module Model
    class Factory
      def self.create(type = :unknown)
        class_name = type.to_s.classify

        unless Arbor::Model.const_defined?(class_name, false)
          type_class = Class.new(Arbor::Model::Abstract)
          Arbor::Model.const_set(class_name, type_class)
        end

        Arbor::Model.const_get(class_name)
      end
    end
  end
end