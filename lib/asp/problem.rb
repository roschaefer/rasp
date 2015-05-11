module Asp
  class Problem
    include Asp::Solving

    def initialize(encoding_string)
      @string_encoding = encoding_string
    end

    # @return [Boolean] if solutions to the problem exist.
    def satisfiable?
      not solutions.empty?
    end

    # @return [Boolean] if problem is unsatisfiable.
    def unsatisfiable?
      not satisfiable?
    end

    # @return [Array<Asp::Solution>] all solutions to the problem.
    def solutions
      solve(@string_encoding)
    end
  end
end
