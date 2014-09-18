module Arbor
  module Model
    class NoOpSerialiser
      def self.deserialise(data)
        data
      end
    end
  end
end