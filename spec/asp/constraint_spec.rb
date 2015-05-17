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
        constraint = Asp::Constraint.new do
          never { "a." }
        end
        expect(constraint.asp_representation).to eq ":- a."
      end
    end
  end
end
