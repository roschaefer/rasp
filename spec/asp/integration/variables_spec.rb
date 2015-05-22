require 'spec_helper'

describe "integration test" do
  before(:each) do
    class OutputClass
      include Asp::Element
    end

    class PropertyClass
      def self.asp(opts={})
        defaults = { :attribute => "A"}
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
      problem.never { PropertyClass.asp() }
      expect(problem.solutions).to be_empty
    end

    it "variables are bound" do
      problem.never { PropertyClass.asp(:attribute => "b")  }
      expect(problem.solutions).to correspond_with [["a", "property(a)"]]
    end

  end

end
