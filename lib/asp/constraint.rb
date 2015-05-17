module Asp
  class Constraint
    attr_accessor :asp_representation

    def self.from(init_string)
      instance = self.new
      instance.asp_representation = init_string
      instance
    end

  end
end
