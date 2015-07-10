require 'spec_helper'

describe Asp::Element do
  context "nested elements" do
    before(:each) do 
      class ContainerElement
        include Asp::Element
        attr_reader :reference
        def self.asp_attributes
          [:a, :b, NestedElement, :c]
        end

        def assign_reference(element)
          if element.is_a?(NestedElement)
            if ([element.x, element.y] == @asp_init_value[NestedElement].values_at(:x, :y))
              @reference = element
              true
            end
          end
        end
      end

      class NestedElement
        include Asp::Element
        asp_schema :x, :y
        attr_reader :x, :y
        def asp_initialize(option_hash)
          @x = option_hash[:x]
          @y = option_hash[:y]
        end
      end

    end

    after(:each) do
      Asp::Memory.instance.forget!
    end

    describe "#option_hash" do
      it "returns nested hashes" do
        string = "containerelement(a,b,nestedelement(x,y),c)"
        expected = {:a => "a", :b => "b", NestedElement => {:x => "x", :y => "y"}, :c => "c"}
        expect(ContainerElement.option_hash(string)).to eq expected
      end
    end



    describe "Problem with nested terms" do
      let(:problem) { Asp::Problem.new "containerelement(foo,bar,nestedelement(23,42), baz). nestedelement(23,42)." }
      before(:each) do
        problem.post_processing do |solution, element|
          if element.respond_to?(:assign_reference)
            solution.find {|e| element.assign_reference(e) }
          end
        end
      end

      it "assigns the correct reference" do
        solution = problem.solutions.first
        expect(solution).to have(2).items
        container = solution.first
        nested = solution.last
        expect(container.reference).to equal(nested)
      end

      it "doesn't assign the wrong cross-reference" do
        problem.add "nestedelement(47,11)."
        solution = problem.solutions.first
        expect(solution).to have(3).items
        container = solution.first
        another_element = solution.last
        expect(another_element.x).to eq "47"
        expect(another_element.y).to eq "11"
        expect(container.reference).not_to be_nil
        expect(container.reference).not_to equal(another_element)
      end
    end
  end
end
