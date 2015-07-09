module Asp
  module Element
    def self.included(target)
      Asp::Memory.instance.remember(target)
      target.include(InstanceMethods)
      target.extend(ClassMethods)
    end

    module InstanceMethods
      def initialize(asp_init_value={})
        @asp_init_value = asp_init_value
      end

      def asp_representation
        values = self.class.asp_attributes.collect { |a| @asp_init_value[a] }
        "#{self.class.to_s.downcase}\(#{values.join(",")}\)"
      end
    end

    module ClassMethods
      def asp_regex
        wildcards = self.asp_attributes.collect { "(.+)" }
        /#{self.to_s.downcase}\(#{wildcards.join(",")}\)/
      end

      def match?(string)
        string =~ self.asp_regex
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
        elements = string.scan(self.asp_regex)
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
