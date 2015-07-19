module Asp
  class SoftConstraint < Generator
    def initialize(cost, opts={}, &block)
      @name = opts[:name] || "penalty"
      @values = opts[:values] || []
      @asp_representation = "#const costs_of_#{@name} = #{cost}."
      @asp_representation << "\n"
      @asp_representation << "penalty(\"#{@name}\", #{@name}(#{@values.join(",")}), costs_of_#{@name}) :- "
      @asp_representation << instance_eval(&block)
      @asp_representation << "."
      self
    end
  end
end
