require 'spec_helper'

describe Asp::Constraint do
  describe "#asp_representation" do
    it "produces a penalty" do
      constraint = Asp::SoftConstraint.new(10) { "a" }
      expect(constraint.asp_representation).to include 'penalty("penalty", costs_of_penalty) :- a.'
    end

    it "sets a constant for the penalty cost" do
      constraint = Asp::SoftConstraint.new(10) { "a" }
      expect(constraint.asp_representation).to include "#const costs_of_penalty = 10."
    end
  end
end
