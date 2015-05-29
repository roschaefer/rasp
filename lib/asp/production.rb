module Asp
  class Production < Generator
    class UnsafeVariablesError < StandardError
    end

    def initialize(result, attribute_hash={}, &block)
      @asp_representation = evaluate_result(result, attribute_hash)
      if block_given?
        @asp_representation << " :- "
        @asp_representation << instance_eval(&block)
      end
      @asp_representation << "."
      self
    end

    def evaluate_result(result, attribute_hash)
      if (result.respond_to? :asp)
        unsafe_variables = result.asp_attributes - attribute_hash.keys
        unless (unsafe_variables.empty?)
          raise UnsafeVariablesError.new(unsafe_variables)
        end
        result.asp(attribute_hash)
      else
        result.to_s
      end
    end

  end
end
