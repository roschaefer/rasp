module Asp
  class Constraint
    attr_accessor :asp_representation

    def self.from(init_string)
      instance = self.new
      instance.asp_representation = init_string
      instance
    end


    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def never(&block)
      self.asp_representation = ":- " + instance_eval(&block)
    end

  end
end
