require 'spec_helper'

describe "integration test" do
  before(:each) do
    class OutputClass
      include Asp::Element
      attr_accessor :asp_string
      def self.from(asp_string)
        instance = self.new
        instance.asp_string = asp_string
        instance
      end

      def ==(other_object)
        if other_object.respond_to?(:asp_string)
          self.asp_string == other_object.asp_string
        else
          super
        end
      end
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
      problem.add(Asp::Constraint.new { never { PropertyClass.asp() } })
      expect(problem.solutions).to be_empty
    end

    it "variables are bound" do
      problem.add(Asp::Constraint.new { never { PropertyClass.asp(:attribute => "b") } })
      expect(problem.solutions).to eq [[OutputClass.from("a"), OutputClass.from("property(a)")]]
    end

  end

end
