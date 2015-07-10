module Asp
  class Problem
    include Asp::Solving

    def initialize(encoding_string=nil)
      @knowledge = []
      @soft_constraint_count = 0
      add(encoding_string) if encoding_string
    end

    def add(knowledge)
      @knowledge << knowledge
    end

    def never(&block)
      add(Asp::Constraint.new(&block))
      self
    end

    def avoid(costs, opts={}, &block)
      if (@soft_constraint_count == 0)
        add("#minimize {C,N : penalty(N,C)}.")
      end
      @soft_constraint_count += 1
      opts[:name] ||= "penalty_#{@soft_constraint_count}"
      add(Asp::SoftConstraint.new(costs, opts, &block))
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

    # @return [Array<Asp::Solution>]
    def solutions
      solutions = []
      solve(self.asp_representation) do |solution|
        solution =  parse(solution)
        solution.each do |element|
          @post_processing.call(solution,element)
        end
        solutions << solution
      end
      solutions
    end

    def post_processing(&block)
      @post_processing = block
    end


    # @todo check for ambiguous matches
    def parse(solution_json)
      costs = solution_json["Costs"][0] if solution_json["Costs"]
      result = Asp::Solution.new(costs)
      solution_json.each do |key, value|
        value.each do |init_string|
          matching_class = mind.well_known_classes.find{|aclass| aclass.match?(init_string) }
          if (matching_class)
            result << matching_class.from(init_string)
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
