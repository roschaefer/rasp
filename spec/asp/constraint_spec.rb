require 'spec_helper'

describe Asp::Constraint do
  context "string initialization" do
    subject { Asp::Constraint.from("a.") }

    describe "#to_asp" do
      its(:asp_representation) { is_expected.to eq( "a." )}
    end
  end

  context "block initialization" do
    describe "#never" do
      it "prepends nil constraint" do
        constraint = Asp::Constraint.new { never { "a." } }
        expect(constraint.asp_representation).to eq ":- a."
      end
    end

    context "cardinalities" do
      describe "#more_than" do
        it "wraps set paranthesis with cardinality" do
          constraint = Asp::Constraint.new { more_than(1) { "b"} }
          expect(constraint.asp_representation).to eq " 1 { b }."
        end
      end

      describe "#at_most" do
        it "wraps set paranthesis with cardinality" do
          constraint = Asp::Constraint.new { at_most(1) { "b"} }
          expect(constraint.asp_representation).to eq " { b } 1."
        end
      end
    end

    context "with Asp::Element classes" do
      before(:each) do
        class SomeClass
          include Asp::Element
        end
      end

      it "default asp represenation of a class occurs" do
        constraint = Asp::Constraint.new { never { SomeClass.asp } }
        expect(constraint.asp_representation).to eq  ":- someclass."
      end

      describe "#conjunct" do
        it do
          constraint = Asp::Constraint.new { conjunct {[SomeClass.asp, SomeClass.asp]} }
          expect(constraint.asp_representation).to eq "someclass, someclass."
        end
      end

    end
  end
end
