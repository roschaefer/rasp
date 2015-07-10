module Asp
  module Element
    def self.included(target)
      Asp::Memory.instance.remember(target)
      target.include(InstanceMethods)
      target.extend(ClassMethods)
    end

    module InstanceMethods
      def asp_initialize(asp_init_value={})
        @asp_init_value = asp_init_value
      end

      def asp_representation
        values = self.class.asp_attributes.collect { |a| @asp_init_value[a] }
        "#{self.class.to_s.downcase}\(#{values.join(",")}\)"
      end
    end

    module ClassMethods
      def asp_regex
        wildcards = self.asp_attributes.collect do |attribute|
          if (attribute.respond_to? :asp_regex)
            # nested element
            "(?<#{attribute}>#{attribute.asp_regex.to_s})"
          else
            "(?<#{attribute}>.+)"
          end
        end
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
        new_instance = new()
        new_instance.asp_initialize(option_hash(string))
        new_instance
      end

      def option_hash(string)
        matchdata = self.asp_regex.match(string)
        pairs = self.asp_attributes.collect{|a| [a, matchdata[a.to_s]]}
        option_hash = Hash[pairs]
        option_hash.each {|k, v| option_hash[k] = k.option_hash(v) if (k.respond_to?(:option_hash)) }
        option_hash
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
