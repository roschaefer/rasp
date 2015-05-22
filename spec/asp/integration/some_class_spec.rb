require 'spec_helper'

describe "integration test" do
  before(:each) do
    class SomeClass
      include Asp::Element

      def ==(other_object)
        if other_object.respond_to?(:init_string)
          self.init_string == other_object.init_string
        else
          super
        end
      end

    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end


  it "without constraints" do
    problem = Asp::Problem.new( "a. b. c." )
    expect(problem.solutions.first).to have(3).items
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
      expected = [SomeClass.from("b")]
      expect(problem.solutions.first).to eq expected
    end

    context "nested with more_than_one" do
      it "never a." do
        problem = Asp::Problem.new( "1 { a ; b ; c  }." )
        problem.never { more_than(2) { "a ; b ; c" } }
        expected = [[SomeClass.from("a")], [SomeClass.from("b")], [SomeClass.from("c")]]
        expect(problem.solutions).to match_array expected
      end
    end
  end

  context "nonmonotonic reasoning" do
    it "statement holds without additional knowledge" do
      problem = Asp::Problem.new "a."
      problem.add(Asp::Constraint.from("c :- a, not b."))
      expected = [SomeClass.from("a"), SomeClass.from("c")]
      expect(problem.solutions.first).to eq expected
    end

    it "statement is refuted with additional knowledge" do
      problem = Asp::Problem.new "a."
      problem.add(Asp::Constraint.from("c :- a, not b."))
      problem.add("b.")
      expected = [SomeClass.from("a"), SomeClass.from("b")]
      expect(problem.solutions.first).to eq expected
    end
  end
end
