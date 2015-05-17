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

    def more_than_one(&block)
      " 1 { " + instance_eval(&block) + " }"
    end

    def conjunct(&block)
      array = instance_eval(&block)
      array.join(", ")
    end
  end
end
