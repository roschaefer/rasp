module Asp
  class Problem
    include Asp::Solving

    def initialize(encoding_string)
      @string_encoding = encoding_string
    end

    def add(knowledge)
      if (knowledge.respond_to?(:asp_representation))
          @string_encoding += "\n" + knowledge.asp_representation
      else
          @string_encoding += "\n" + knowledge.to_s
      end
    end

    def never(&block)
      add(Asp::Constraint.never(&block))
    end

    def asp_representation
      @string_encoding
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
        value.each do |element|
          matching_class = mind.well_known_classes.find { |aclass| aclass.match?(element) }
          if (matching_class)
            result << matching_class.new(:init_string => element)
          end
        end
      end
      result
    end

    private
    def mind
      Asp::Memory.instance
    end
  end
end
