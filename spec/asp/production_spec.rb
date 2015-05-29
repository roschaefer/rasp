require 'spec_helper'
describe Asp::Production  do
  describe "#make" do
    context "without block" do
      subject { Asp::Production.new("anything") }
      its(:asp_representation) { is_expected.to eq "anything." }
    end

    context "single block" do
      subject { Asp::Production.new("something") { "for_a_reason" } }
      its(:asp_representation) { is_expected.to eq "something :- for_a_reason." }
    end

    context "nested block" do
      subject { Asp::Production.new("love") { no { "war" }} }
      its(:asp_representation) { is_expected.to eq "love :- not war." }
    end
  end
end
