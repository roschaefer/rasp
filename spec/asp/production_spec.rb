require 'spec_helper'
describe Asp::Production  do
  context "without block" do
    subject { Asp::Production.new("anything") }
    its(:asp_representation) { is_expected.to eq "anything." }
  end

  context "block containing a string" do
    subject { Asp::Production.new("something") { "for_a_reason" } }
    its(:asp_representation) { is_expected.to eq "something :- for_a_reason." }
  end

  context "nested block" do
    describe "#no" do
      subject { Asp::Production.new("love") { no { "war" }} }
      its(:asp_representation) { is_expected.to eq "love :- not war." }
    end

    describe "#no #more_than" do
      subject { Asp::Production.new("tired") { no { more_than(5) { "coffee" }} } }
      its(:asp_representation) { is_expected.to eq "tired :- not 6 { coffee }." }
    end
  end

  context "result is an Asp::Element" do
    before(:each) do
      class DesiredResult 
        include Asp::Element
      end
      class DesiredResultWithAttributes
        include Asp::Element
        asp_schema :a, :b
      end
    end

    describe "no attributes" do
      subject { Asp::Production.new(DesiredResult) }
      its(:asp_representation) { is_expected.to eq "desiredresult()." }
    end

    describe "missing attributes" do
      it { expect{ Asp::Production.new(DesiredResultWithAttributes) }.to raise_error(Asp::Production::UnsafeVariablesError, /\[:a, :b\]/) }
    end

    describe "bound attributes" do
      subject { Asp::Production.new(DesiredResultWithAttributes, :a => "foo", :b => "bar") }
      its(:asp_representation) { is_expected.to eq "desiredresultwithattributes(foo,bar)." }
    end
  end
end
