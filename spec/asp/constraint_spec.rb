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

    describe "#more_than_one" do
      it "wraps set paranthesis with cardinality" do
        constraint = Asp::Constraint.new { more_than_one { "b."} }
        expect(constraint.asp_representation).to eq " 1 { b. }"
      end
    end

    context "with Asp::Element classes" do
      it "default asp representation is lowercased class name" do
        class SomeClass
          include Asp::Element
        end
        constraint = Asp::Constraint.new { never { SomeClass.asp } }
        expect(constraint.asp_representation).to eq  ":- someclass."
      end
    end
  end
end
