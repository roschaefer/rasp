require 'spec_helper'
describe "dating agency" do
  before(:each) do
    class Love
      include Asp::Element
      asp_schema :name
    end

    class Person
      include Asp::Element
      def self.match?(string)
        nil
      end
      def initialize(name, sex, status)
        @name = name || "_"
        @sex = sex || "_"
        @status = status || "_"
      end
      def asp_representation
        "person(\"#{@name}\", #{@sex}, #{@status})"
      end

      asp_schema :name, :sex, :relationship_status
    end
  end

  after(:all) do
    Asp::Memory.instance.forget!
  end


  context "online dating site" do
    subject (:problem) {
        Asp::Problem.new().tap do |p|
          p.add(Person.new("Alice", :female, :single))
          p.add(Person.new("Bob",   :male,   :single))
          p.add(Person.new("Carla", :female, :married))
          p.add("{ love(NAME) } 1 :- person(NAME,_,_)")
        end
    }

    before(:each) do
      problem.never { less_than(1) { Love.asp } }
      problem.never { more_than(1) { Love.asp } }
    end

    let(:solo_constraint) do
      problem.never { conjunct{ [Love.asp(:name => "NAME"), Person.asp(:name => "NAME", :relationship_status => "married")] } }
    end

    let(:female_constraint) do
      problem.never { conjunct{[ Love.asp(:name => "NAME"), Person.asp(:name => "NAME", :sex => "male")] } }
    end

    its(:solutions) { are_expected.to correspond_with [['love("Alice")'], ['love("Bob")'], ['love("Carla")']] }

    it "only females" do
      female_constraint
      expect(problem.solutions).to correspond_with [['love("Alice")'], ['love("Carla")']]
    end

    it "only singles" do
      solo_constraint
      expect(problem.solutions).to correspond_with [['love("Alice")'], ['love("Bob")']]
    end

    it "only female singles" do
      solo_constraint; female_constraint
      expect(problem.solutions).to correspond_with [['love("Alice")']]
    end
  end

end
