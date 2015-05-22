module Asp
  module Element
    def self.included(target)
      Asp::Memory.instance.remember(target)
      target.include(InstanceMethods)
      target.extend(ClassMethods)
    end

    module InstanceMethods
      def initialize(opts={})
        @init_string = opts[:init_string]
      end

      def init_string
        @init_string
      end
    end

    module ClassMethods
      def match?(string)
        true
      end

      def from(string)
        self.new(:init_string => string)
      end

      def asp
        self.to_s.downcase
      end
    end
  end
end
