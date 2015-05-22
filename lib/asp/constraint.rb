module Asp
  class Constraint
    attr_accessor :asp_representation
    private_class_method :new

    def self.from(init_string)
      instance = new
      instance.asp_representation = init_string
      instance
    end

    def self.never(&block)
      instance = new
      instance.asp_representation = ":- "
      instance.block_initialize(&block)
      instance
    end


    def block_initialize(&block)
      self.asp_representation << instance_eval(&block)
      self.asp_representation << "."
    end

    def more_than(cardinality, &block)
      "#{cardinality} { " + instance_eval(&block) + " }"
    end

    def at_most(cardinality, &block)
      "{ " + instance_eval(&block) + " } #{cardinality}"
    end

    def conjunct(&block)
      array = instance_eval(&block)
      array.join(", ")
    end
  end
end
