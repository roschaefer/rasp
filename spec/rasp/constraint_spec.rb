require 'spec_helper'

describe Rasp::Constraint do
  let(:init_string) { "a." }
  subject { Rasp::Constraint.new(init_string) }

  describe "#to_asp" do
    subject { super().to_asp }
    it { is_expected.to eq  "a." }
  end
end
