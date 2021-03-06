require 'spec_helper'

describe "integration test" do
  before(:each) do
    class SomeClass
      include Asp::Element
      def self.match?(string)
        true
      end
      def initialize(string)
        @asp_init_value = string
      end
      def self.from(string)
        new(string)
      end
      def asp_representation
        @asp_init_value
      end
    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end


  it "without constraints" do
    problem = Asp::Problem.new( "a. b. c." )
    expect(problem.solutions).to correspond_with [["a","b","c"]]
  end

  context "never constraint" do
    it "never a." do
      problem = Asp::Problem.new( "a. b. c." )
      problem.never { "a"  }
      expect(problem.solutions).to be_empty
    end

    it "never a." do
      problem = Asp::Problem.new( "1 { a ; b }." )
      problem.never { "a"  }
      expect(problem.solutions).to correspond_with [["b"]]
    end

    context "nested with more_than_one" do
      it "never a." do
        problem = Asp::Problem.new( "1 { a ; b ; c  }." )
        problem.never { more_than(1) { "a ; b ; c" } }
        expect(problem.solutions).to correspond_with [["a"], ["b"], ["c"]]
      end
    end
  end

  context "nonmonotonic reasoning" do
    it "statement holds without additional knowledge" do
      problem = Asp::Problem.new "a."
      problem.add("c :- a, not b.")
      expect(problem.solutions).to correspond_with [["a", "c"]]
    end

    it "statement is refuted with additional knowledge" do
      problem = Asp::Problem.new "a."
      problem.add("c :- a, not b.")
      problem.add("b.")
      expect(problem.solutions).to correspond_with [["a","b"]]
    end
  end
end
