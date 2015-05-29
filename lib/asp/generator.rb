module Asp
  class Generator
    attr_reader :asp_representation

    def no(&block)
      "not #{instance_eval(&block)}"
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

  end
end
