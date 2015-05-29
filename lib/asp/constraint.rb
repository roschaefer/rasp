require 'asp/constraint/same'
module Asp
  class Constraint
    attr_reader :asp_representation

    def initialize(&block)
      @asp_representation = ":- "
      @asp_representation << instance_eval(&block)
      @asp_representation << "."
      self
    end

    def more_than(cardinality, &block)
      "#{cardinality+1} { " + instance_eval(&block) + " }"
    end

    def less_than(cardinality, &block)
      "{ " + instance_eval(&block) + " } #{cardinality-1}"
    end

    def conjunct(&block)
      array = instance_eval(&block)
      array.join(", ")
    end

    def same(*attributes)
      Asp::Constraint::Same.new(*attributes)
    end
  end
end
