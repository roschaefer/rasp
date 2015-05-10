require 'spec_helper'

describe Rasp::Problem do
  context "empty set" do
    it { is_expected.to be_satisfiable }
  end
end
