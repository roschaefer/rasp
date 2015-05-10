require 'spec_helper'

describe Asp::Problem do
  context "empty set" do
    it { is_expected.to be_satisfiable }
    its(:solutions) { are_expected.to have(1).item }
  end
end
