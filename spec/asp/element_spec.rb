require 'spec_helper'

describe Asp::Element do
  before(:each) do
    class AnElement
      include Asp::Element
      def self.from(string)
        if (string.include?("a"))
          new
        else
          nil
        end
      end
    end
  end

  after(:each) do
      Asp::Memory.instance.forget!
      Object.send(:remove_const, :AnElement)
  end

  context "overridden included methods" do
    it { expect(AnElement.from("a")).not_to be_nil }
    it { expect(AnElement.from("b")).to be_nil }
  end

  context "facts only problem" do
    let(:init_string) { "a." }
    let(:problem) { Asp::Problem.new(init_string) }
    let(:element)   { problem.solutions.first.first }
    it { expect(problem.solutions.first).to be_a(Array) }
    it { expect(element).to be_kind_of(Asp::Element) }
  end
end
