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

      def asp(opts={})
        underscores = self.asp_attributes.collect { "_" }
        attribute_names_with_underscores = self.asp_attributes.zip(underscores).flatten
        defaults = Hash[*attribute_names_with_underscores]
        opts = defaults.merge(opts)
        opts = opts.select { |key, value| self.asp_attributes.include?(key) }
        "#{self.to_s.downcase}(#{opts.values.join","})"
      end

      def from(string)
        wildcards = self.asp_attributes.collect { "(.+)" }
        regex = /#{self.to_s.downcase}\(#{wildcards.join(",")}\)/
        elements = string.scan(regex)
        option_hash = Hash[asp_attributes.zip(*elements)]
        new(option_hash)
      end

      def asp_attributes
        []
      end


      # Shorthand to define asp attributes
      #
      # == Parameters:
      # format::
      #   An Array of symbols with the attributes' names
      # (see ::asp_attributes)
      def asp_schema(*attributes)
        define_singleton_method :asp_attributes do
          attributes
        end
      end
    end
  end
end
