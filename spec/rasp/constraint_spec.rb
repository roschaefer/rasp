require 'spec_helper'

describe Rasp::Constraint do
  let(:init_string) { "a." }
  subject { Rasp::Constraint.new(init_string) }

  describe "#export" do
    specify { subject.export.should eq init_string }
  end
end
