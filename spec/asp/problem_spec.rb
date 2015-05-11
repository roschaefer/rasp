require 'spec_helper'

describe Asp::Problem do
  subject { Asp::Problem.new(string_encoding) }

  context "invalid syntax" do
    let(:string_encoding) { "missing_dot" }
    it { expect{ subject.satisfiable? }.to raise_exception(Asp::Solving::InvalidSyntaxException) }
  end

  context "empty set" do
    let(:string_encoding) { "" }
    it { is_expected.to be_satisfiable }
    its(:solutions) { are_expected.to have(1).item }
  end

  context "self negation" do
    let(:string_encoding) { "a:- not a." }
    it { is_expected.to be_unsatisfiable }
    its(:solutions) { are_expected.to have(0).item }
  end

  context "choice rule" do
    let(:string_encoding) do
      %{{ a ; b} .
        :- a, not b.
        :- b, not a. }
    end
    it { is_expected.to be_satisfiable }
    its(:solutions) { are_expected.to have(2).items }
  end
end
