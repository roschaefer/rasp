module Asp
  class Problem

    # @return [Boolean] if solutions to the problem exist.
    def satisfiable?
      true
    end

    # @return [Array<Asp::Solution>] all solutions to the problem.
    def solutions
      [[]]
    end
  end
end
