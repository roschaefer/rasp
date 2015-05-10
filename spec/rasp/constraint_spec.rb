require 'spec_helper'

describe Rasp::Constraint do
  let(:init_string) { "a." }
  subject { Rasp::Constraint.new(init_string) }

  describe "#to_asp" do
    its(:to_asp) { is_expected.to eq( "a." )}
  end
end
