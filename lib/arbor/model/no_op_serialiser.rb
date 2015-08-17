module Arbor
  module Model
    class NoOpSerialiser
      def self.load(data)
        data
      end
    end
  end
end