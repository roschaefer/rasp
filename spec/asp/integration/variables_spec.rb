require 'spec_helper'

describe "integration test" do
  before(:each) do
    class Property
      include Asp::Element
      def self.asp_attributes
        [:attribute]
      end
    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end

  context "variables" do
    let(:problem) { Asp::Problem.new("property(a).") }

    it "variables are not set" do
      problem.never { Property.asp() }
      expect(problem.solutions).to be_empty
    end

    it "variables are bound" do
      problem.never { Property.asp(:attribute => "b")  }
      expect(problem.solutions).to correspond_with [["property(a)"]]
    end
  end
end
