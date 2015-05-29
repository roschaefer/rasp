module Asp
  class Production < Generator
    def initialize(result, &block)
      @asp_representation = result.to_s
      if block_given?
        @asp_representation << " :- "
        @asp_representation << instance_eval(&block)
      end
      @asp_representation << "."
      self
    end
  end
end
