require 'spec_helper'
describe "dating agency" do
  before(:each) do
    class Love
      include Asp::Element
      asp_schema :name
      def self.match?(string)
        string.include?("love")
      end
    end

    class Person
      include Asp::Element
      def self.match?(string)
        nil
      end
      asp_schema :name, :sex, :relationship_status
    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end
  context "restrictions" do
    let(:problem) { Asp::Problem.new(
      %{person("Alice", female, single).
         person("Bob", male, single).
         person("Carla", female, relationship).
         { love(NAME) } 1 :- person(NAME,_,_).}
    ) }

    it "we want them all" do
      problem.never { less_than(1) { Love.asp } }
      problem.never { more_than(1) { Love.asp } }
      expect(problem.solutions).to correspond_with [ ['love("Alice")'], ['love("Bob")'], ['love("Carla")']]
    end

    it "only solo females" do
      problem.never { less_than(1) { Love.asp } }
      problem.never { conjunct{[
          Love.asp(:name => "NAME"),
          Person.asp(:name => "NAME", :sex => "male")]
      } }
      problem.never { conjunct{[
          Love.asp(:name => "NAME"),
          Person.asp(:name => "NAME", :relationship_status => "relationship")]
      } }
      expect(problem.solutions).to correspond_with [['love("Alice")']]
    end
  end

end
