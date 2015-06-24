module Asp
  class SoftConstraint < Generator
    def initialize(cost, opts={}, &block)
      opts[:name] ||= "penalty"
      @asp_representation = "#const costs_of_#{opts[:name]} = #{cost}."
      @asp_representation << "\n"
      @asp_representation << "penalty(\"#{opts[:name]}\", costs_of_#{opts[:name]}) :- "
      @asp_representation << instance_eval(&block)
      @asp_representation << "."
      self
    end
  end
end
