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

  context "traveller advice" do
    let(:problem) { Asp::Problem.new("""
                    0 \{vaccination(hepatitisB)\} 1.
                    0 \{vaccination(rabies)\} 1.
                    0 \{copy(D)\} 2 :- document(D).
                    document(passport).
                    document(driver_licence).
                   """) }


    it "problem has got 16 possible solutions" do
      expect(problem.solutions).to have(16).items
    end

    it "it's better to have a copy of your passport" do
      problem.avoid(5) { no { "copy(passport)" } }
      expect(problem.solutions).to have(8).items
    end

    it "hopefully you have got all your shots" do
      problem.avoid(5) { less_than(2) { "vaccination(_)" } }
      expect(problem.solutions).to have(4).items
    end

    it "the best is to have all your shots and enough copies of your documents" do
      problem.avoid(5) { less_than(2) { "vaccination(_)" } }
      problem.avoid(3) { less_than(2) { "copy(_)" } }
      expect(problem.solutions).to have(1).item
    end
  end
end
