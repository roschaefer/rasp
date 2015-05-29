module Asp
  class Production
    attr_reader :asp_representation

    def initialize(result, &block)
      @asp_representation = result.to_s
      if block_given?
        @asp_representation << " :- "
        @asp_representation << instance_eval(&block)
      end
      @asp_representation << "."
      self
    end

    def no(&block)
      "not #{instance_eval(&block)}"
    end
  end
end
