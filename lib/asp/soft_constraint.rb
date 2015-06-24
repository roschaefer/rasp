module Asp
  class SoftConstraint < Generator
    def initialize(cost, &block)
      @asp_representation = "#const costs_of_penalty = #{cost}."
      @asp_representation << "\n"
      @asp_representation << "penalty(\"penalty\", costs_of_penalty) :- "
      @asp_representation << instance_eval(&block)
      @asp_representation << "."
      self
    end
  end
end
