require 'spec_helper'

describe Asp::Constraint do

  describe "hard constraints" do
    it "asp representation always starts with :-" do
      constraint = Asp::Constraint.new { "a" }
      expect(constraint.asp_representation).to eq ":- a."
    end

    describe "cardinalities" do
      describe "#more_than" do
        it "wraps set parenthesis with cardinality" do
          constraint = Asp::Constraint.new { more_than(1) { "b"} }
          expect(constraint.asp_representation).to eq ":- 2 { b }."
        end
      end

      describe "#less_than" do
        it "wraps set parenthesis with cardinality" do
          constraint = Asp::Constraint.new { less_than(2) { "b"} }
          expect(constraint.asp_representation).to eq ":- { b } 1."
        end
      end
    end

    describe "#conjunct" do
      it "comma separated items" do
        constraint = Asp::Constraint.new { conjunct{["a", "b", "c"]} }
        expect(constraint.asp_representation).to eq ":- a, b, c."
      end
    end

    context "wrap Asp::Element" do
      before(:each) do
        class SomeClass
          include Asp::Element
        end
      end

      it "default asp representation of a class occurs" do
        constraint = Asp::Constraint.new { SomeClass.asp }
        expect(constraint.asp_representation).to eq  ":- someclass()."
      end

      describe "#conjunct" do
        it do
          constraint = Asp::Constraint.new { conjunct {[SomeClass.asp, SomeClass.asp]} }
          expect(constraint.asp_representation).to eq ":- someclass(), someclass()."
        end
      end


      describe "#same" do
        before(:each) do
          allow(SomeClass).to receive(:asp_attributes).and_return([:a])

          class AnotherClass
            include Asp::Element
            def self.asp_attributes
              [:a, :b]
            end
          end

          class YetAnotherClass
            include Asp::Element
            def self.asp_attributes
              [:b]
            end
          end
        end

        it "checks if several classes have the same attribute"  do
          constraint = Asp::Constraint.new { same(:a).for(SomeClass, AnotherClass)  }
          expect(constraint.asp_representation).to eq ":- someclass(A0), anotherclass(A0,_)."
        end

        it "many different attributes can be compared across several classes" do
          constraint = Asp::Constraint.new { same(:a, :b).for(SomeClass, AnotherClass, YetAnotherClass) }
          expect(constraint.asp_representation).to eq ":- someclass(A0), anotherclass(A0,B1), yetanotherclass(B1)."
        end
      end

    end
  end
end
