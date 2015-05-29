module Asp
  class Constraint < Generator

    def initialize(&block)
      @asp_representation = ":- "
      @asp_representation << instance_eval(&block)
      @asp_representation << "."
      self
    end

    def same(*attributes)
      Asp::Constraint::Same.new(*attributes)
    end
  end
end
