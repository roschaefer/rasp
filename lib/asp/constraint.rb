require 'asp/constraint/same'
module Asp
  class Constraint
    attr_accessor :asp_representation
    private_class_method :new

    def initialize(opts = {})
      self.asp_representation = opts[:init_string]
    end

    def self.from(init_string)
      new(:init_string => init_string)
    end

    def self.never(&block)
      instance = new(:init_string => ":- ")
      instance.block_initialize(&block)
      instance
    end


    def block_initialize(&block)
      self.asp_representation << instance_eval(&block)
      self.asp_representation << "."
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
