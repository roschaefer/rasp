module Rasp
  class Constraint

    def initialize(init_string)
      @string_representation = init_string
    end

    # @return [String] A string representing the constraint in ASP
    def to_asp
      @string_representation
    end
  end
end
