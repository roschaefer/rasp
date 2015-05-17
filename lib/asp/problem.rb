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

    # @return [Array<Array<Asp::Element>>] array of array containing all solutions of the problem.
    def solutions
      solutions = []
      solve(@string_encoding) do |solution|
        solutions << parse(solution)
      end
      solutions
    end


    # @todo check for ambiguous matches
    def parse(solution)
      result = []
      solution.each do |key, value|
        matches = mind.well_known_classes.collect { |aclass| aclass.from(value) }.compact
        result << matches.first
      end
      result
    end

    private
    def mind
      Asp::Memory.instance
    end
  end
end
