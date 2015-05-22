require 'spec_helper'

describe "integration test" do
  before(:each) do
    class OutputClass
      include Asp::Element
    end

    class InputClass
      def self.asp(opts={})
        defaults = { :attribute => "_"}
        opts = defaults.merge(opts)
        "property(#{opts[:attribute]})"
      end
    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end

  context "variables" do
    let(:problem) { Asp::Problem.new("a. property(a).") }

    it "variables are not set" do
      problem.never { InputClass.asp() }
      expect(problem.solutions).to be_empty
    end

    it "variables are bound" do
      problem.never { InputClass.asp(:attribute => "b")  }
      expect(problem.solutions).to correspond_with [["a", "property(a)"]]
    end
  end
end
