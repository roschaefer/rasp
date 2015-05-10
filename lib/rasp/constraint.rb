module Rasp
  class Constraint

    def initialize(init_string)
      @init_string = init_string
    end

    def to_asp
      @init_string
    end
  end
end
