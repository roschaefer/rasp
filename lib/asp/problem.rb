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
      self
    end

    def never(&block)
      add(Asp::Constraint.new(&block))
      self
    end

    def avoid(costs, opts={}, &block)
      if (@soft_constraint_count == 0)
        add("#minimize {C,N,V : penalty(N,V,C)}.")
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
        sanitize(part)
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
    def solutions(opts = {})
      solutions = []
      solve(self.asp_representation) do |solution|
        solution =  parse(solution)
        if solution.optimal.nil? || solution.optimal || opts[:suboptimal] # if optimal.nil? then there was no optimization
          solutions << solution
        end
        if @post_processing
          solution.each do |element|
            @post_processing.call(solution,element)
          end
        end
      end
      solutions
    end

    def post_processing(&block)
      @post_processing = block
    end


    # @todo check for ambiguous matches
    def parse(solution_json)
      optimal = solution_json["Optimal"]
      costs = solution_json["Costs"][0] if solution_json["Costs"]
      result = Asp::Solution.new(costs, optimal)
      solution_json["Value"].each do |init_string|
        matching_class = mind.well_known_classes.find{|aclass| aclass.match?(init_string) }
        if (matching_class)
          result << matching_class.from(init_string)
        end
      end
      result
    end

    private
    def mind
      Asp::Memory.instance
    end

    def sanitize(part)
      method = [:asp_representation, :asp].find {|m| part.respond_to?(m) }
      unless method.nil?
        result = part.send(method)
      else
        result = part.to_s
      end
      result.strip!
      result << "." unless result.empty? || result.end_with?('.')
      result
    end
  end
end
