module Asp
  class Problem
    include Asp::Solving

    def initialize(encoding_string=nil)
      @knowledge = []
      add(encoding_string) if encoding_string
    end

    def add(knowledge)
      @knowledge << knowledge
    end

    def never(&block)
      add(Asp::Constraint.new(&block))
      self
    end

    def make(result, &block)
      add(Asp::Production.new(result, &block))
      self
    end

    def asp_representation
      evaluated_knowledge = @knowledge.map do |part|
        if (part.respond_to?(:asp_representation))
          part.asp_representation
        else
          part.to_s
        end
      end
      evaluated_knowledge.join("\n")
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
      solve(self.asp_representation) do |solution|
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
