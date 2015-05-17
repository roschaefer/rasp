require 'spec_helper'

describe Asp::Element do
  before(:each) do
    eval(%{
    class AnElement
      include Asp::Element
    end
         })
  end

  after(:each) { Asp::Memory.instance.forget! }

  context "included methods" do
    specify { expect(AnElement.from("a.")).not_to be_nil }
  end

  context "facts only problem" do
    let(:init_string) { "a." }
    let(:problem) { Asp::Problem.new(init_string) }
    let(:element)   { problem.solutions.first.first }
    it { expect(problem.solutions.first).to be_a(Array) }
    it { expect(element).to be_kind_of(Asp::Element) }
  end
end
