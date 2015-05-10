require 'spec_helper'

describe Asp::Constraint do
  let(:init_string) { "a." }
  subject { Asp::Constraint.new(init_string) }

  describe "#to_asp" do
    its(:to_asp) { is_expected.to eq( "a." )}
  end
end
