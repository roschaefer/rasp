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
  end
end
