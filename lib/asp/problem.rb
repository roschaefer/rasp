module Asp
  class Problem

    def initialize(encoding_string)
    end

    # @return [Boolean] if solutions to the problem exist.
    def satisfiable?
      true
    end

    # @return [Boolean] if problem is unsatisfiable.
    def unsatisfiable?
      not satisfiable?
    end

    # @return [Array<Asp::Solution>] all solutions to the problem.
    def solutions
      [[]]
    end
  end
end
