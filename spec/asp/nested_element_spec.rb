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



  end
end
