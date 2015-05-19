require 'spec_helper'

describe "integration test" do
  let (:problem) { Asp::Problem.new(init_string) }
  let(:init_string) { "a. b. c." }

  before(:each) do
    class SomeClass
      include Asp::Element
    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end


  it "without constraints" do
    expect(problem.solutions.first).to have(3).items
  end

  it "no a. constraint" do
    constraint = Asp::Constraint.new { never { "a." } }
    problem.add(constraint)
    expect(problem.solutions).to be_empty
  end
end
