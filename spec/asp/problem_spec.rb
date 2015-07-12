require 'spec_helper'
require 'timeout'

describe Asp::Problem do
  context "invalid syntax" do
    subject { Asp::Problem.new( "missing_dot" ) }
    it { expect{ subject.satisfiable? }.to raise_exception(Asp::Solving::InvalidSyntaxException) }
  end

  context "empty set" do
    subject { Asp::Problem.new("") }
    it { is_expected.to be_satisfiable }
    its(:solutions) { are_expected.to have(1).item }
  end

  context "self negation" do
    subject { Asp::Problem.new("a:- not a." ) }
    it { is_expected.to be_unsatisfiable }
    its(:solutions) { are_expected.to have(0).item }
  end

  context "choice rule" do
    subject { Asp::Problem.new(
      %{{ a ; b} .
        :- a, not b.
        :- b, not a. }
    ) }
    it { is_expected.to be_satisfiable }
    its(:solutions) { are_expected.to have(2).items }
  end

  describe "#never" do
    subject { Asp::Problem.new.never { "say_never" }}
    it "initializes and adds a constraint" do
      expect(subject.asp_representation).to eq ":- say_never."
    end
  end

  describe "#make" do
    subject { Asp::Problem.new.make("something") { "up" }}
    it "initializes and adds a production rule" do
      expect(subject.asp_representation).to eq "something :- up."
    end
  end

  describe "#avoid" do
    subject { Asp::Problem.new.avoid(23) { "scams" }}
    it "initializes and adds a soft constraint" do
        expect(subject.asp_representation).to include "#const costs_of_penalty_1 = 23."
        expect(subject.asp_representation).to include "penalty(\"penalty_1\", costs_of_penalty_1) :- scams."
    end

    it "adds exactly one minimize statement" do
      subject.avoid(42) { "more_terrible_scams" }
      optimize_statements = subject.asp_representation.scan("#minimize {C,N : penalty(N,C)}.")
      expect(optimize_statements).to have(1).item
    end


    it "solutions have costs" do
      subject.add( "scams.")
      expect(subject.solutions.first.costs).to eq 23
    end

    it "solutions are still optimal" do
      subject.add( "scams.")
      expect(subject.solutions.first).to be_optimal
    end
  end


  describe "#timeout" do
    subject { Asp::Problem.new """
        1 { sudoku(1..9,Y,N) } 1 :- Y=1..9, N=1..9.
        1 { sudoku(X,1..9,N) } 1 :- X=1..9, N=1..9.
        1 { sudoku(X,Y,1..9) } 1 :- X=1..9, Y=1..9.

        :- sudoku(X1,Y1,N), sudoku(X2,Y2,N), (X1,Y1) != (X2,Y2), (((X1-1)/3),((Y1-1)/3)) == (((X2-1)/3), ((Y2-1)/3)).
      """ }

    it "limits the execution time" do
      subject.timeout(1)
      Timeout::timeout(4) do
        expect(subject.solutions).not_to be_empty
      end
    end
  end

  describe "#post_processing" do
    subject { Asp::Problem.new "foobar(x). foobar(y)." }
    it "calls the block on the solution and each contained element" do
      class Foobar
        include Asp::Element
        asp_schema :a
      end
      expect(Foobar).to receive(:block_was_called!).exactly(2).times
      subject.post_processing do |solution, element|
        expect(solution).to have(2).items # one solution with two foobars
        element.class.block_was_called!
      end
      subject.solutions
    end
  end

  describe "#solutions" do
    let(:problem) do 
      problem =  Asp::Problem.new "1 { foo; bar } 1."
      problem.avoid(23) { "foo" }
      problem.avoid(42) { "bar" }
    end

    it "by default, only returns optimal solutions" do
      solutions = problem.solutions
      expect(solutions).to have(1).item
      solution = solutions.first
      expect(solution).to be_kind_of(Asp::Solution)
      expect(solution.costs).to eq 23
      expect(solution).to be_optimal
    end

    it "with :suboptimal=true, also returns suboptimal solutions" do
      solutions = problem.solutions(:suboptimal => true)
      expect(solutions).to have_at_least(2).items
      suboptimal = solutions.find {|s| s.optimal? == false }
      expect(suboptimal).not_to be_nil
      expect(suboptimal.costs).to eq 42
    end
  end

end
