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
end
