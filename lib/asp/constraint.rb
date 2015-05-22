module Asp
  class Constraint
    attr_accessor :asp_representation

    def self.from(init_string)
      instance = self.new
      instance.asp_representation = init_string
      instance
    end


    def initialize(&block)
      block_initialize(&block) if block_given?
    end

    def block_initialize(&block)
      self.asp_representation = instance_eval(&block) if block_given?
      unless self.asp_representation.end_with?(".")
        self.asp_representation << "."
      end
    end

    def never(&block)
      ":- " + instance_eval(&block)
    end

    def more_than(cardinality, &block)
      " #{cardinality} { " + instance_eval(&block) + " }"
    end

    def at_most(cardinality, &block)
      " { " + instance_eval(&block) + " } #{cardinality}"
    end

    def conjunct(&block)
      array = instance_eval(&block)
      array.join(", ")
    end
  end
end
