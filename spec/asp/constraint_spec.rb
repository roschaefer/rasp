require 'spec_helper'

describe Asp::Constraint do
  context "string initialization" do
    subject { Asp::Constraint.from("a.") }

    describe "#to_asp" do
      its(:asp_representation) { is_expected.to eq( "a." )}
    end
  end

  context "block initialization" do
    describe "::never" do
      it "prepends nil constraint" do
        constraint = Asp::Constraint.never { "a" }
        expect(constraint.asp_representation).to eq ":- a."
      end
    end

    context "cardinalities" do
      describe "#more_than" do
        it "wraps set paranthesis with cardinality" do
          constraint = Asp::Constraint.never { more_than(1) { "b"} }
          expect(constraint.asp_representation).to eq ":- 2 { b }."
        end
      end

      describe "#less_than" do
        it "wraps set paranthesis with cardinality" do
          constraint = Asp::Constraint.never { less_than(2) { "b"} }
          expect(constraint.asp_representation).to eq ":- { b } 1."
        end
      end
    end

    describe "#conjunct" do
      it "comma separated items" do
        constraint = Asp::Constraint.never { conjunct{["a", "b", "c"]} }
        expect(constraint.asp_representation).to eq ":- a, b, c."
      end
    end

    context "with Asp::Element classes" do
      before(:each) do
        class SomeClass
          include Asp::Element
        end
      end

      it "default asp representation of a class occurs" do
        constraint = Asp::Constraint.never { SomeClass.asp }
        expect(constraint.asp_representation).to eq  ":- someclass()."
      end

      describe "#conjunct" do
        it do
          constraint = Asp::Constraint.never { conjunct {[SomeClass.asp, SomeClass.asp]} }
          expect(constraint.asp_representation).to eq ":- someclass(), someclass()."
        end
      end


      describe "same" do
        it "checks if several classes have the same attribute"  do
          class AnotherClass
            include Asp::Element
          end
          constraint = Asp::Constraint.never { same(:attribute => "A") { [SomeClass, AnotherClass] } }
          expect(constraint.asp_representation).to eq ":- someclass(A), anotherclass(A)."
        end
      end

    end
  end
end
