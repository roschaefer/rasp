require 'spec_helper'

describe Rasp::Constraint do
  let(:init_string) { "a." }
  subject { Rasp::Constraint.new(init_string) }

  describe "#to_asp" do
    specify { expect(subject.to_asp).to eq init_string }
  end
end
