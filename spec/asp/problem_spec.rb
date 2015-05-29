require 'spec_helper'

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

  describe "#make" do
    context "without block" do
      subject { Asp::Problem.new.make("something") }
      its(:asp_representation) { is_expected.to eq "something :- ." }
    end

    context "single block" do
      subject { Asp::Problem.new.make("something") { "for_a_reason" } }
      its(:asp_representation) { is_expected.to eq "something :- for_a_reason." }
    end

    context "nested block" do
      subject { Asp::Problem.new.make("love") { no { "war" }} }
      its(:asp_representation) { is_expected.to eq "love:- not war." }
    end
  end
end
